#!/usr/bin/env bash
# Usage: get-token.sh <graphql-url> <email> <password>
# Prints a backoffice JWT. The API expects the password derived the way the backoffice does it.
set -euo pipefail

url=$1 email=$2 password=$3

key=$(node -e '
  const crypto = require("crypto");
  const [password, email] = process.argv.slice(1);
  process.stdout.write(crypto.pbkdf2Sync(password, email, 100000, 64, "sha512").toString("base64"));
' "$password" "$email")

body=$(jq -nc --arg email "$email" --arg password "$key" '{
  query: "mutation Login($input: LoginInput!) { login(input: $input) { result token } }",
  variables: { input: { email: $email, password: $password } }
}')

response=$(curl -s "$url" -H 'content-type: application/json' -d "$body")
token=$(jq -r '.data.login.token // empty' <<<"$response")

if [[ -z $token ]]; then
  echo "Login failed: $response" >&2
  exit 1
fi
echo "$token"
