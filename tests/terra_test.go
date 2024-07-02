package test

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"testing"
	"time"

	_ "github.com/go-sql-driver/mysql"
	"github.com/gruntwork-io/terratest/modules/docker"
	"github.com/gruntwork-io/terratest/modules/retry"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

const (
	vaultUrl   = "http://localhost:8200"
	vaultToken = "test"
	dbPass     = "mypass"
	dbUser     = "root"
	dbHost     = "localhost"
	dbPort     = "3306"
)

func TestTerragrunt(t *testing.T) {
	workDir := "../envs/dev"
	dockerOpts := &docker.Options{
		WorkingDir: workDir,
		EnvVars: map[string]string{
			"COMPOSE_FILE": "docker-compose.yaml",
		},
	}

	_ = os.Remove(workDir + "/terraform.tfstate")

	defer docker.RunDockerCompose(t, dockerOpts, "down")
	docker.RunDockerCompose(t, dockerOpts, "up", "-d")

	waitForDatabase(t, fmt.Sprintf("%s:%s@tcp(%s:%s)/%s", dbUser, dbPass, dbHost, dbPort, "mysql"))
	waitForVault(t)

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir:    workDir,
		TerraformBinary: "terragrunt",
		EnvVars: map[string]string{
			"TF_ENCRYPTION": `key_provider "pbkdf2" "mykey" {passphrase = "somekeynotverysecure"}`,
		},
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.Apply(t, terraformOptions)

	secret, err := readVaultSecret(vaultUrl, vaultToken, "secret/data/env/dev/mariadb/keycloak/soeren")
	assert.NoError(t, err)
	assert.Contains(t, secret, "password")
	readPassword := secret["password"].(string)
	readUser := "soeren"

	waitForDatabase(t, fmt.Sprintf("%s:%s@tcp(%s:%s)/%s", readUser, readPassword, dbHost, dbPort, "keycloak"))
}

func readVaultSecret(vaultAddr, token, secretPath string) (map[string]interface{}, error) {
	url := fmt.Sprintf("%s/v1/%s", vaultAddr, secretPath)

	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		return nil, fmt.Errorf("failed to create request: %v", err)
	}

	req.Header.Set("X-Vault-Token", token)
	client := &http.Client{
		Timeout: 1 * time.Second,
	}
	resp, err := client.Do(req)
	if err != nil {
		return nil, fmt.Errorf("failed to send request: %v", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("unexpected response status: %s", resp.Status)
	}
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("failed to read response body: %v", err)
	}

	var responseData map[string]interface{}
	if err := json.Unmarshal(body, &responseData); err != nil {
		return nil, fmt.Errorf("failed to parse JSON response: %v", err)
	}

	data, ok := responseData["data"].(map[string]interface{})
	if !ok {
		return nil, fmt.Errorf("unexpected response structure")
	}

	secretData, ok := data["data"].(map[string]interface{})
	if !ok {
		return nil, fmt.Errorf("unexpected secret data structure")
	}

	return secretData, nil
}

func waitForVault(t *testing.T) {
	retry.DoWithRetry(t, "Waiting for vault service", 45, 1*time.Second, func() (string, error) {
		resp, err := http.Get(vaultUrl + "/ui/")
		if err != nil {
			return "", err
		}
		defer resp.Body.Close()

		if resp.StatusCode != 200 {
			return "", fmt.Errorf("expected HTTP status 200 but got %d", resp.StatusCode)
		}

		return "Service is available", nil
	})
}

func waitForDatabase(t *testing.T, dsn string) {
	retry.DoWithRetry(t, "Waiting for database service", 45, 1*time.Second, func() (string, error) {
		db, err := sql.Open("mysql", dsn)
		if err != nil {
			return "", fmt.Errorf("failed to open MySQL connection: %v", err)
		}
		defer db.Close()

		// Try pinging the database
		err = db.Ping()
		if err != nil {
			return "", fmt.Errorf("MySQL not ready: %v", err)
		}
		return "Db is available", nil
	})
}
