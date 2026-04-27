# 📋 Checklist de Implementação: Arquitetura PDV/ERP

## 🗄️ Fase 1: Infraestrutura e Banco de Dados (Multi-DB)
> Objetivo: Configurar a redundância e separação de escrita/leitura.

- [✅] **Configurar Docker Compose:** Adicionar dois serviços de banco (Primary e Replica) e um serviço Redis.
- [✅] **Configurar Replicação:** Definir o `db_replica` como slave do `db_primary` no arquivo de conf do Postgres/Oracle.
- [✅] **Mapear database.yml:** Configurar os contextos de `writing` e `reading` no Rails.
- [✅] **Ativar Conexão Automática:** Configurar o `ApplicationRecord` para alternar entre bancos com base no método (GET vs POST).
- [✅] **Persistência Redis:** Configurar o volume do Redis com `appendonly yes` para não perder tokens em reboots.

## 🔑 Fase 2: Segurança e Controle de Acesso
> Objetivo: Implementar as travas de Hardware e Sessão.

- [ ] **Fingerprint Identity:** Implementar no Frontend (Angular/Ionic) a geração de Hash de hardware.
- [ ] **Whitelist de Dispositivos:** Criar tabela `authorized_devices` no Rails vinculada à `Institution`.
- [ ] **Middleware de Bloqueio:** Criar `before_action` no Rails que valida se o Hash do dispositivo está autorizado.
- [ ] **Auto-Token Worker:** Implementar lógica de expiração de JWT baseada no horário de turno do usuário.
- [ ] **Log de Heartbeat:** Criar job para registrar atividade do usuário no Redis para monitoramento de produtividade.

## 🚀 Fase 3: Backend & Background Processing (Rails)
> Objetivo: Garantir que a API seja rápida e não sofra gargalos.

- [ ] **Configurar Sidekiq:** Integrar o Redis como fila de processamento em segundo plano.
- [ ] **Async Vendas:** Criar `VendaWorker` para processar baixa de estoque e fiscal fora da thread principal.
- [ ] **Cache de Relatórios:** Implementar `Rails.cache` usando Redis para armazenar resultados de leituras pesadas.
- [ ] **Multi-tenancy:** Instalar e configurar a gem `acts_as_tenant` para isolar os dados por Instituição.

## 📱 Fase 4: Frontend & Mobile (Angular/Ionic)
> Objetivo: Criar as interfaces consumindo a API única.

- [ ] **Service de Autenticação:** Criar interceptor para injetar o JWT e o Hardware ID em todos os headers.
- [ ] **Store com Signals:** Implementar o estado global da aplicação (estoque/venda) usando Angular Signals (Zoneless).
- [ ] **Offline Mode (Mobile):** Configurar Service Workers no Ionic para permitir vendas básicas sem internet.
- [ ] **Logoff Forçado:** Implementar listener que limpa o LocalStorage quando o backend retornar `401 Unauthorized`.