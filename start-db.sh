#!/bin/bash

docker run -d \
    --name postgres-dev \
    -e POSTGRES_USER=surajit \
    -e POSTGRES_PASSWORD=tijarus \
    -e POSTGRES_DB=mydb \
    -p 5432:5432 \
    -v pgdata:/var/lib/postgresql/data \
    postgres:15-alpine

echo "PostgreSQL started on localhost:5432"
echo "Database: mydb"
echo "User: myuser"
