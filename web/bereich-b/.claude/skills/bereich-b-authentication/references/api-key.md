# Rotate the SuperAdmin API Key — bereich-b (Payload CMS v3)

The .NET backend authenticates to bereich-b using the `admin@example.com`
Benutzer's Payload **API key** (`enableAPIKey: true`, `useAPIKey: true` on the
collection). Rotating it means: generate a new key, PATCH it onto the user via
the Payload REST API, then sync it into the .NET `user-secrets` (and the
bereich-b `.env` if present). Run the steps **in order** — each depends on the
previous.

## Step 1 — Log in as super admin

```bash
TOKEN=$(curl -s -X POST http://localhost:3001/cms/api/benutzer/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@example.com","password":"123456"}' | jq -r '.token')
echo "Token: $TOKEN"
```

## Step 2 — Get the admin user id

```bash
ADMIN_ID=$(curl -s http://localhost:3001/cms/api/benutzer/me \
  -H "Authorization: JWT $TOKEN" | jq -r '.user.id')
echo "Admin ID: $ADMIN_ID"
```

## Step 3 — Generate a new API key

```bash
NEW_API_KEY=$(uuidgen | tr '[:upper:]' '[:lower:]')
echo "New API Key: $NEW_API_KEY"
```

## Step 4 — Set the key on the user via Payload REST

```bash
curl -s -X PATCH "http://localhost:3001/cms/api/benutzer/$ADMIN_ID" \
  -H "Authorization: JWT $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"apiKey\":\"$NEW_API_KEY\",\"enableAPIKey\":true}" \
  | jq '{ id: .doc.id, email: .doc.email, enableAPIKey: .doc.enableAPIKey }'
```

## Step 5 — Store it in the .NET backend user-secrets

```bash
cd backend/API && dotnet user-secrets set "BereichB:SuperAdminApiKey" "$NEW_API_KEY"
```

## Step 6 — Ensure the admin has `isSuperAdmin`

Production dumps sometimes drop this flag. Set it in MongoDB (collection
`benutzers`):

```bash
docker exec hameln-mongodb mongosh --quiet \
  "mongodb://admin:password@localhost:27017/bereich-b?authSource=admin" \
  --eval "db.benutzers.updateOne({ email: 'admin@example.com' }, { \$set: { isSuperAdmin: true } })"
```

## Step 7 — Sync the bereich-b `.env` (if it pins the key)

```bash
grep PAYLOAD_API_KEY web/bereich-b/.env   # check current value
sed -i '' "s/PAYLOAD_API_KEY=.*/PAYLOAD_API_KEY=$NEW_API_KEY/" web/bereich-b/.env
```

## Step 8 — Restart

Restart both bereich-b and the .NET backend so they pick up the new key.
