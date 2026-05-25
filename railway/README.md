# Railway deployment

This repo is deployed as two Railway services:

- `hermes`: builds the root `Dockerfile`, runs `gateway run`, stores data in `/opt/data`.
- `caddy`: builds `railway/caddy/Dockerfile`, exposes the public domain, protects the dashboard with Basic Auth, and forwards `/telegram` to Hermes without Basic Auth.

## Hermes service

Create a Railway service from this GitHub repo with root directory `/`.

Settings:

- Start command: `gateway run`
- Volume mount path: `/opt/data`
- Public networking: disabled

Environment variables: use `railway/hermes.env.example`.

## Caddy service

Create another Railway service from the same GitHub repo.

Settings:

- Root directory: `railway/caddy`
- Public networking: enabled

Environment variables: use `railway/caddy.env.example`.

Generate the Basic Auth password hash locally:

```bash
docker run --rm caddy:2 caddy hash-password --plaintext "your-strong-password"
```

Then set:

```env
DASHBOARD_USER=admin
DASHBOARD_PASSWORD_HASH=<hash>
```

After Railway gives the Caddy service a public domain, set Hermes:

```env
TELEGRAM_WEBHOOK_URL=https://<your-caddy-domain>/telegram
```
