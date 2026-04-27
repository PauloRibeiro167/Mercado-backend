#!/bin/bash
set -e

echo "==== Configurando o Primary para Replicação ===="

# Altera o usuário principal para ter permissão de REPLICATION
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    ALTER ROLE "$POSTGRES_USER" REPLICATION;
EOSQL

# Adiciona a permissão no pg_hba.conf para permitir conexões de replicação
echo "host replication $POSTGRES_USER 0.0.0.0/0 scram-sha-256" >> "$PGDATA/pg_hba.conf"

echo "==== Configuração do Primary concluída ===="