set -a
if [ -f .env ]; then
  # shellcheck disable=SC1091
  . .env
else
  echo ".env file not found in $(pwd)" >&2
fi
set +a
