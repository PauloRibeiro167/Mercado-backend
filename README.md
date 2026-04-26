# Mercadinho Backend

API Rails para o sistema de mercadinho.

## 🚀 Início Rápido

### Com Docker (Recomendado)

1. Configure as variáveis de ambiente em `.env.development`.

2. Suba os containers:
   ```bash
   docker-compose up -d
   ```

3. Execute as migrações:
   ```bash
   docker-compose exec app rails db:migrate
   ```

4. Acesse a API em http://localhost:3000

### Local

1. Instale Ruby 3.x e Rails.

2. Instale dependências:
   ```bash
   bundle install
   ```

3. Configure o banco de dados em `config/database.yml`.

4. Execute migrações:
   ```bash
   rails db:migrate
   ```

5. Inicie o servidor:
   ```bash
   rails server
   ```

## 📁 Estrutura

- `api/`: Código da aplicação Rails
- `config/`: Configurações
- `db/`: Migrações e seeds
- `spec/`: Testes RSpec
- `bin/`: Scripts utilitários

## 🧪 Testes

```bash
rspec
```

## 📚 Documentação

A documentação da API está disponível via Swagger em `/api-docs`.
