#!/bin/sh
set -e

DB_USER="${POSTGRES_USER:-postgres}"
DB_NAME="${POSTGRES_DB:-$DB_USER}"

if [ -n "$POSTGRES_PASSWORD" ]; then
  export PGPASSWORD="$POSTGRES_PASSWORD"
fi

(
  until pg_isready -h localhost -U "$DB_USER"; do
    sleep 1
  done
  
  if ! psql -U "$DB_USER" -h localhost -d postgres -tc "SELECT 1 FROM pg_database WHERE datname = '$DB_NAME'" | grep -q 1; then
    echo "Database $DB_NAME does not exist. Creating..."
    psql -U "$DB_USER" -h localhost -d postgres -c "CREATE DATABASE \"$DB_NAME\";"
  else
    echo "Database $DB_NAME already exists."
  fi
) &

exec docker-entrypoint.sh "$@"
