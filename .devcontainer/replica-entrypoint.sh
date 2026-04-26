#!/bin/bash
set -e

# Verifica se o diretório de dados está vazio ou não inicializado
if [ ! -s "$PGDATA/PG_VERSION" ]; then
    echo "==== Inicializando Replica a partir do Primary ===="
    
    # Limpa o diretório caso tenha lixo gerado por inicialização padrão
    rm -rf "$PGDATA"/*

    # Aguarda o primary ficar pronto e aceitar conexões
    until pg_isready -h postgres-primary -p 5432 -U "$POSTGRES_USER"; do
        echo "Aguardando postgres-primary ficar online..."
        sleep 2
    done

    echo "Primary está pronto. Executando pg_basebackup..."
    PGPASSWORD="$POSTGRES_PASSWORD" pg_basebackup -h postgres-primary -D "$PGDATA" -U "$POSTGRES_USER" -vP

    echo "Criando arquivo standby.signal..."
    touch "$PGDATA/standby.signal"

    echo "Configurando string de conexão com o primary..."
    echo "primary_conninfo = 'host=postgres-primary port=5432 user=$POSTGRES_USER password=$POSTGRES_PASSWORD'" >> "$PGDATA/postgresql.auto.conf"
    echo "==== Backup concluído com sucesso ===="
fi

echo "Iniciando o PostgreSQL na Réplica..."
exec docker-entrypoint.sh "$@"