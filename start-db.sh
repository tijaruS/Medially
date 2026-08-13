#!/bin/bash
set -euo pipefail

CONTAINER_NAME="postgres-dev"
HOST_NETWORK_CONTAINER_NAME="postgres-dev-host-5433"
POSTGRES_USER="surajit"
POSTGRES_PASSWORD="tijarus"
POSTGRES_DB="mydb"
POSTGRES_PORT="5432"
HOST_NETWORK_POSTGRES_PORT="5433"

active_container=""
active_port="$POSTGRES_PORT"

start_host_network_container() {
    if docker ps --format '{{.Names}}' | grep -qx "$HOST_NETWORK_CONTAINER_NAME"; then
        echo "PostgreSQL is already running on localhost:${HOST_NETWORK_POSTGRES_PORT}"
    elif docker ps -a --format '{{.Names}}' | grep -qx "$HOST_NETWORK_CONTAINER_NAME"; then
        docker start "$HOST_NETWORK_CONTAINER_NAME" >/dev/null
        echo "PostgreSQL host-network container started on localhost:${HOST_NETWORK_POSTGRES_PORT}"
    else
        docker run -d \
            --name "$HOST_NETWORK_CONTAINER_NAME" \
            --network host \
            -e POSTGRES_USER="$POSTGRES_USER" \
            -e POSTGRES_PASSWORD="$POSTGRES_PASSWORD" \
            -e POSTGRES_DB="$POSTGRES_DB" \
            -v pgdata:/var/lib/postgresql/data \
            postgres:15-alpine \
            -c "port=${HOST_NETWORK_POSTGRES_PORT}" >/dev/null
        echo "PostgreSQL host-network container created on localhost:${HOST_NETWORK_POSTGRES_PORT}"
    fi

    active_container="$HOST_NETWORK_CONTAINER_NAME"
    active_port="$HOST_NETWORK_POSTGRES_PORT"
}

if docker ps --format '{{.Names}}' | grep -qx "$HOST_NETWORK_CONTAINER_NAME"; then
    echo "PostgreSQL is already running on localhost:${HOST_NETWORK_POSTGRES_PORT}"
    active_container="$HOST_NETWORK_CONTAINER_NAME"
    active_port="$HOST_NETWORK_POSTGRES_PORT"
elif docker ps --format '{{.Names}}' | grep -qx "$CONTAINER_NAME"; then
    echo "PostgreSQL is already running on localhost:${POSTGRES_PORT}"
    active_container="$CONTAINER_NAME"
elif docker ps -a --format '{{.Names}}' | grep -qx "$CONTAINER_NAME"; then
    if docker start "$CONTAINER_NAME" >/dev/null 2>/tmp/medially-postgres-start-error; then
        echo "PostgreSQL container started on localhost:${POSTGRES_PORT}"
        active_container="$CONTAINER_NAME"
    else
        cat /tmp/medially-postgres-start-error
        echo "Falling back to host networking on port ${HOST_NETWORK_POSTGRES_PORT} because Docker bridge networking is unavailable."
        start_host_network_container
    fi
elif docker ps -a --format '{{.Names}}' | grep -qx "$HOST_NETWORK_CONTAINER_NAME"; then
    start_host_network_container
else
    docker run -d \
        --name "$CONTAINER_NAME" \
        -e POSTGRES_USER="$POSTGRES_USER" \
        -e POSTGRES_PASSWORD="$POSTGRES_PASSWORD" \
        -e POSTGRES_DB="$POSTGRES_DB" \
        -p "${POSTGRES_PORT}:5432" \
        -v pgdata:/var/lib/postgresql/data \
        postgres:15-alpine >/dev/null
    echo "PostgreSQL container created on localhost:${POSTGRES_PORT}"
    active_container="$CONTAINER_NAME"
fi

until docker exec "$active_container" pg_isready -U "$POSTGRES_USER" -d "$POSTGRES_DB" -p "$active_port" >/dev/null 2>&1; do
    if ! docker ps --format '{{.Names}}' | grep -qx "$active_container"; then
        docker logs --tail 40 "$active_container"
        exit 1
    fi
    sleep 1
done

export DATABASE_URL="postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@localhost:${active_port}/${POSTGRES_DB}?schema=public"

if [ "$active_port" != "$POSTGRES_PORT" ]; then
    printf 'DATABASE_URL="%s"\n' "$DATABASE_URL" > .env.local
    echo "Wrote .env.local with DATABASE_URL on localhost:${active_port}"
fi

npx prisma db push

echo "Database is ready"
echo "Database: ${POSTGRES_DB}"
echo "User: ${POSTGRES_USER}"
