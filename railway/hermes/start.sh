#!/bin/sh
set -eu

ENV_FILE="/opt/data/.env"

# Railway Variables are the source of truth for deployment secrets. Hermes also
# loads $HERMES_HOME/.env. On Railway+s6, the wrapper can see service env vars
# before /init, while the later gateway process may not. Mirror selected Railway
# vars into the persistent Hermes .env so the gateway reads the intended values.
mkdir -p "$(dirname "$ENV_FILE")"
touch "$ENV_FILE"
chmod 600 "$ENV_FILE" 2>/dev/null || true

for key in TELEGRAM_BOT_TOKEN TELEGRAM_ALLOWED_USERS GATEWAY_ALLOW_ALL_USERS; do
  eval "value=\${$key:-}"
  if [ -n "$value" ]; then
    tmp="${ENV_FILE}.tmp"
    grep -v "^${key}=" "$ENV_FILE" > "$tmp" || true
    printf '%s=%s\n' "$key" "$value" >> "$tmp"
    mv "$tmp" "$ENV_FILE"
    chmod 600 "$ENV_FILE" 2>/dev/null || true
    echo "Railway env synced for ${key}."
  fi
done

if [ -f "$ENV_FILE" ]; then
  chown hermes:hermes "$ENV_FILE" 2>/dev/null || true
fi

exec /init /opt/hermes/docker/main-wrapper.sh gateway run
