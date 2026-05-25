#!/bin/sh
set -eu

ENV_FILE="/opt/data/.env"

# Railway Variables are the source of truth for deployment secrets. Hermes also
# loads $HERMES_HOME/.env with override=True, so stale values written by the web
# UI can shadow Railway's environment. Remove those stale entries when Railway
# has the value set.
if [ -f "$ENV_FILE" ]; then
  for key in TELEGRAM_BOT_TOKEN TELEGRAM_ALLOWED_USERS GATEWAY_ALLOW_ALL_USERS; do
    eval "value=\${$key:-}"
    if [ -n "$value" ]; then
      tmp="${ENV_FILE}.tmp"
      grep -v "^${key}=" "$ENV_FILE" > "$tmp" || true
      cat "$tmp" > "$ENV_FILE"
      rm -f "$tmp"
      echo "Railway env override active for ${key}; removed stale ${ENV_FILE} entry if present."
    fi
  done
fi

exec /init /opt/hermes/docker/main-wrapper.sh gateway run
