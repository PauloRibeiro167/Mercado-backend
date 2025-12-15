CYAN=\e[1;36m
GREEN=\e[1;32m
YELLOW=\e[1;33m
RED=\e[1;31m
MAGENTA=\e[1;35m
BLUE=\e[1;34m
NC=\e[0m
CLEAR_LINE = tput cuu1 && tput el
COMPOSE_FILE = .devcontainer/compose.yaml
ENV_FILE = .env.development
DOCKERFILE ?= .devcontainer/Dockerfile
IMAGE_NAME ?= $(PROJECT_NAME)_image
DOCKERFILE_DEPS = $(shell cat $(DOCKERFILE) | tr '\n' ' ' | sed 's/.*apt-get install -y --no-install-recommends //;s/ &&.*//')
APP_SERVICE_NAME = mercado-app
APP_SERVICE_BACKEND = mercado-backend-app
PROJECT_NAME ?= $(shell grep -E '^(export )?PROJECT_NAME=' $(ENV_FILE) | sed 's/^export //' | cut -d '=' -f2)
DB ?= $(shell grep -E '^DB=' $(ENV_FILE) | cut -d '=' -f2)
DB_USER ?= $(shell grep -E '^(export )?POSTGRES_USER=' $(ENV_FILE) | sed 's/^export //' | cut -d '=' -f2)
DB_NAME ?= $(shell grep -E '^(export )?POSTGRES_DB=' $(ENV_FILE) | sed 's/^export //' | cut -d '=' -f2)
DOCKER = docker compose -f $(COMPOSE_FILE)  --env-file $(ENV_FILE) -p $(PROJECT_NAME)
NOCACHE ?= 0
MAKEFLAGS += --no-print-directory
BACKEND_WORKDIR ?= /workspaces/backend
BACKEND_PORT ?= 3000
PROJECT_WORKDIR ?= /workspaces

.PHONY: help build build-no-cache rebuild up down exec exec-workspace exec-ui logs logs-backend ps db-shell clean env-check rm-env regen-env

help:
	@printf "$(CYAN)Comandos disponíveis:$(NC)\n"
	@printf "  $(BLUE)help$(NC)         		$(YELLOW)- Mostra esta ajuda.$(NC)\n"
	@printf "  $(BLUE)build$(NC)        		$(YELLOW)- Builda a imagem Docker manualmente.$(NC)\n"
	@printf "  $(BLUE)build-no-cache$(NC) 	$(YELLOW)- Builda a imagem Docker SEM cache.$(NC)\n"
	@printf "  $(BLUE)rebuild$(NC)      		$(YELLOW)- Força o rebuild da imagem e recria os containers.$(NC)\n"
	@printf "  $(BLUE)up$(NC)           		$(YELLOW)- Sobe os containers e faz build se necessário.$(NC)\n"
	@printf "  $(BLUE)down$(NC)         		$(YELLOW)- Para e remove todos os containers abertos.$(NC)\n"
	@printf "  $(BLUE)exec$(NC)         		$(YELLOW)- Inicia backend (-d) e abre shell no workspace do projeto.$(NC)\n"
	@printf "  $(BLUE)exec-workspace$(NC)		$(YELLOW)- Abre shell no workspace do projeto (sem iniciar backend).$(NC)\n"
	@printf "  $(BLUE)logs$(NC)         		$(YELLOW)- Mostra os logs do container da UI.$(NC)\n"
	@printf "  $(BLUE)logs-backend$(NC)		$(YELLOW)- Mostra os logs do container do backend.$(NC)\n"
	@printf "  $(BLUE)ps$(NC)           		$(YELLOW)- Lista os containers do projeto.$(NC)\n"
	@printf "  $(BLUE)db-shell$(NC)     		$(YELLOW)- Acessa o shell do banco de dados.$(NC)\n"
	@printf "  $(BLUE)clean$(NC)        		$(YELLOW)- Limpa o ambiente Docker.$(NC)\n\n"

build:
	@printf "$(CYAN)Build da imagem Docker...$(NC)\n"
	@if [ "$(NOCACHE)" = "1" ]; then \
		printf "$(YELLOW)Build sem cache ativado.$(NC)\n"; \
		docker build --no-cache -f $(DOCKERFILE) -t $(IMAGE_NAME) .; \
	else \
		docker build -f $(DOCKERFILE) -t $(IMAGE_NAME) .; \
	fi

build-no-cache:
	@printf "$(YELLOW)Buildando imagem Docker SEM cache...$(NC)\n"
	@NOCACHE=1 $(MAKE) build
	@:

rebuild:
	@printf "$(CYAN)Recriando o ambiente...$(NC)\n"
	@$(MAKE) down
	@$(MAKE) build
	@$(MAKE) up
	@printf "$(GREEN)Ambiente recriado com sucesso.$(NC)\n"

up:
	@if [ ! -f "$(ENV_FILE)" ]; then \
		printf "$(RED)Arquivo de ambiente não encontrado: $(ENV_FILE)$(NC)\n"; \
		printf "$(YELLOW)Crie o arquivo $(ENV_FILE) antes de continuar.$(NC)\n"; \
		exit 1; \
	fi
	@printf "$(CYAN)Subindo containers...$(NC)\n"
	@printf "$(GREEN)Rodando: Docker compose up -d$(NC)\n"
	@$(DOCKER) up -d
	@printf "$(GREEN)Containers estão rodando.$(NC)\n"

down:
	@printf "$(YELLOW)Parando e removendo todos os containers, volumes e redes do projeto...$(NC)\n"
	@$(DOCKER) down -v --remove-orphans

exec:
	@printf "$(CYAN)Iniciando backend Rails em background...$(NC)\n"
	@$(MAKE) start-backend
	@printf "$(CYAN)Abrindo workspace do projeto...$(NC)\n"
	@$(MAKE) exec-workspace

exec-ui:
	@set -e; \
	container_id=$$($(DOCKER) ps --status=running -q $(APP_SERVICE_NAME) 2>/dev/null) || true; \
	if [ -z "$$container_id" ]; then \
		$(MAKE) up; \
		sleep 3; \
		container_id=$$($(DOCKER) ps --status=running -q $(APP_SERVICE_NAME) 2>/dev/null) || true; \
		[ -z "$$container_id" ] && printf "$(RED)Falha ao iniciar o container da UI $(APP_SERVICE_NAME).$(NC)\n" && exit 1; \
	fi; \
	detected_root=$$($(DOCKER) exec $(APP_SERVICE_NAME) bash -lc '\
		set -e; for d in "$(PROJECT_WORKDIR)" /workspaces /workspace /; do \
			if [ -d "$$d" ] && [ -d "$$d/backend" ] && [ -d "$$d/ui" ]; then echo "$$d"; exit 0; fi; \
		done; echo ""'); \
	if [ -z "$$detected_root" ]; then \
		printf "$(RED)Não foi possível localizar a raiz do projeto dentro do container da UI.$(NC)\n"; \
		printf "$(YELLOW)Defina PROJECT_WORKDIR (ex.: /workspaces).$(NC)\n"; \
		exit 1; \
	fi; \
	$(DOCKER) exec -e PROJECT_NAME="$(PROJECT_NAME)" -e CONTAINER_ID="$$container_id" -e DETECTED_ROOT="$$detected_root" -it $(APP_SERVICE_NAME) bash -lc 'cd "$$DETECTED_ROOT/ui"; export PS1="\[\e[1;34m\]${PROJECT_NAME}-ui:\w:\[\e[0m\] "; exec bash --noprofile --norc' || true

exec-backend:
	@set -e; \
	container_id=$$($(DOCKER) ps --status=running -q $(APP_SERVICE_BACKEND) 2>/dev/null) || true; \
	if [ -z "$$container_id" ]; then \
		$(MAKE) up; \
		sleep 4; \
		container_id=$$($(DOCKER) ps --status=running -q $(APP_SERVICE_BACKEND) 2>/dev/null) || true; \
		[ -z "$$container_id" ] && printf "$(RED)Falha ao iniciar o container do backend.$(NC)\n" && exit 1; \
	fi; \
	detected_dir=$$($(DOCKER) exec $(APP_SERVICE_BACKEND) bash -lc '\
		set -e; cand=""; \
		if [ -d "$(BACKEND_WORKDIR)" ] && [ -e "$(BACKEND_WORKDIR)/bin/rails" ]; then cand="$(BACKEND_WORKDIR)"; \
		else for d in /workspaces/backend /workspace/backend /workspaces/*/backend /app /srv/app; do \
			if [ -d "$$d" ] && [ -e "$$d/bin/rails" ]; then cand="$$d"; break; fi; \
		done; fi; echo "$$cand"'); \
	if [ -z "$$detected_dir" ]; then \
		printf "$(RED)Não foi possível detectar o diretório do backend dentro do container.$(NC)\n"; \
		exit 1; \
	fi; \
	$(DOCKER) exec -e PROJECT_NAME="$(PROJECT_NAME)" -e CONTAINER_ID="$$container_id" -it $(APP_SERVICE_BACKEND) bash -lc 'cd "$$detected_dir"; export PS1="\[\e[1;34m\]${PROJECT_NAME}-backend:\w:\[\e[0m\] "; exec bash --noprofile --norc' || true

# Inicia o Rails do backend dentro do container em modo detach
start-backend:
	@set -e; \
	container_id=$$($(DOCKER) ps --status=running -q $(APP_SERVICE_BACKEND) 2>/dev/null) || true; \
	if [ -z "$$container_id" ]; then \
		$(MAKE) up; \
		sleep 4; \
		container_id=$$($(DOCKER) ps --status=running -q $(APP_SERVICE_BACKEND) 2>/dev/null) || true; \
		[ -z "$$container_id" ] && printf "$(RED)Falha ao iniciar o container do backend.$(NC)\n" && exit 1; \
	fi; \
	port=$$(grep -E '^(export )?(BACKEND_PORT|RAILS_PORT)=' "$(ENV_FILE)" 2>/dev/null | sed 's/^export //' | tail -n1 | cut -d'=' -f2); \
	[ -z "$$port" ] && port="$(BACKEND_PORT)"; \
	detected_dir=$$($(DOCKER) exec $(APP_SERVICE_BACKEND) bash -lc '\
		set -e; cand=""; \
		if [ -d "$(BACKEND_WORKDIR)" ] && [ -e "$(BACKEND_WORKDIR)/bin/rails" ]; then cand="$(BACKEND_WORKDIR)"; \
		else for d in /workspaces/backend /workspace/backend /workspaces/*/backend /app /srv/app; do \
			if [ -d "$$d" ] && [ -e "$$d/bin/rails" ]; then cand="$$d"; break; fi; \
		done; fi; echo "$$cand"'); \
	[ -z "$$detected_dir" ] && printf "$(RED)Não foi possível detectar o diretório do backend dentro do container.$(NC)\n" && exit 1; \
	already_running=$$($(DOCKER) exec $(APP_SERVICE_BACKEND) bash -lc 'pgrep -fa "puma|rails s" | grep -q "$$detected_dir" && echo yes || echo no' 2>/dev/null || echo no); \
	if [ "$$already_running" = "yes" ]; then \
		printf "$(GREEN)Backend Rails já está em execução em $$detected_dir na porta $$port.$(NC)\n"; \
		exit 0; \
	fi; \
	printf "$(GREEN)Iniciando Rails em detach (-d) em $$detected_dir na porta $$port...$(NC)\n"; \
	$(DOCKER) exec -d $(APP_SERVICE_BACKEND) bash -lc '\
		set -e; cd "$$detected_dir"; \
		if [ -x bin/rails ]; then bin/rails s -b 0.0.0.0 -p '"$$port"' -e development; \
		elif command -v bundle >/dev/null 2>&1; then bundle exec rails s -b 0.0.0.0 -p '"$$port"' -e development; \
		else rails s -b 0.0.0.0 -p '"$$port"' -e development; fi' || { printf "$(RED)Falha ao iniciar o Rails.$(NC)\n"; exit 1; }; \
	printf "$(GREEN)Rails iniciado em background. Porta: $$port. Use 'make logs-backend' para ver os logs.$(NC)\n"

logs:
	@printf '$(MAGENTA)Mostrando logs do serviço $(APP_SERVICE_NAME)...$(NC)\n'
	container_id=$$($(DOCKER) ps --status=running -q $(APP_SERVICE_NAME)); \
	if [ -z "$$container_id" ]; then \
		printf "$(RED)Nenhum container em execução encontrado para o serviço $(APP_SERVICE_NAME).$(NC)\n"; \
		printf "$(YELLOW)Você pode iniciar os containers com 'make up'.$(NC)\n"; \
		exit 1; \
	fi; \
	printf "$(CYAN)Anexando aos logs... (Pressione Ctrl+C para sair)$(NC)\n"; \
	printf "$(YELLOW)Nota: O container pode não estar gerando logs se estiver ocioso.$(NC)\n"; \
	$(DOCKER) logs -f $(APP_SERVICE_NAME) || true

logs-backend:
	@container_id=$$($(DOCKER) ps --status=running -q $(APP_SERVICE_BACKEND) 2>/dev/null) || true; \
	if [ -z "$$container_id" ]; then \
		printf "$(YELLOW)Container do serviço $(APP_SERVICE_BACKEND) não está rodando. Iniciando com 'make up'...$(NC)\n"; \
		$(MAKE) up; \
		container_id=$$($(DOCKER) ps --status=running -q $(APP_SERVICE_BACKEND) 2>/dev/null) || true; \
		if [ -z "$$container_id" ]; then \
			printf "$(RED)Falha ao iniciar o container.$(NC)\n"; \
			exit 1; \
		fi; \
	fi; \
	logs_output=$$($(DOCKER) logs $(APP_SERVICE_BACKEND) 2>/dev/null); \
	if [ -z "$$logs_output" ]; then \
		printf "$(YELLOW)Nenhum log encontrado para o serviço $(APP_SERVICE_BACKEND). O container pode não ter gerado logs ainda.$(NC)\n"; \
	else \
		printf "$(MAGENTA)Mostrando logs do serviço $(APP_SERVICE_BACKEND)...$(NC)\n"; \
		echo "$$logs_output"; \
	fi

ps:
	@printf '$(BLUE)Listando containers ativos...$(NC)\n'
	@$(DOCKER) ps

db-shell:
	@printf "$(GREEN)Abrindo shell do banco de dados no serviço postgres... (Ctrl+D para sair)$(NC)\n"
	@printf "$(YELLOW)DEBUG: DB_USER=%s DB_NAME=%s$(NC)\n" "$(DB_USER)" "$(DB_NAME)"
	@container_id=$$($(DOCKER) ps --status=running -q postgres); \
	if [ -z "$$container_id" ]; then \
		printf "$(YELLOW)Container do serviço postgres não encontrado. Tentando iniciar com 'make up'...$(NC)\n"; \
		$(MAKE) up; \
		sleep 10; \
		container_id=$$($(DOCKER) ps --status=running -q postgres); \
		if [ -z "$$container_id" ]; then \
			printf "$(RED)Falha ao iniciar ou encontrar o container do serviço postgres. Verifique os logs.$(NC)\n"; \
			exit 1; \
		fi; \
	fi; \
	printf "$(GREEN)Container do banco de dados encontrado: %s$(NC)\n" "$$container_id"; \
	$(DOCKER) exec -it postgres psql -U "$(DB_USER)" "$(DB_NAME)"


clean:
	@clear
	@printf '\n$(MAGENTA)Selecione a opção de limpeza:$(NC)\n'
	@printf '  $(CYAN)[1] Limpar apenas recursos do projeto (compose)$(NC)\n'
	@printf '  $(CYAN)[2] Limpar TODOS os containers, volumes, imagens e redes do Docker$(NC)\n'
	@printf '  $(CYAN)[3] Cancelar$(NC)\n\n'
	@sh -c '\
		while true; do \
			printf "  $(YELLOW)Digite 1, 2 ou 3 e pressione ENTER: $(NC)"; \
			read opt; \
			case "$$opt" in \
				1) \
					printf "$(YELLOW)Limpando apenas recursos do projeto (compose)...$(NC)\n"; \
					$(DOCKER) down -v --remove-orphans; \
					exit 0; \
					;; \
				2) \
					trap "echo; echo -e '\''$(RED)Operação interrompida pelo usuário.$(NC)'\''; exit 130" INT; \
					printf "$(MAGENTA)Tem certeza que deseja remover TODOS os containers, volumes, imagens e redes no Docker? (s/N): $(NC)"; \
					read confirm; \
					if [ "$$confirm" = "s" ] || [ "$$confirm" = "S" ]; then \
						printf "$(RED)Removendo todos os containers, volumes, imagens e redes...$(NC)\n"; \
						docker stop $$(docker ps -aq) 2>/dev/null || true; \
						docker rm $$(docker ps -aq) 2>/dev/null || true; \
						docker volume prune -f; \
						docker network prune -f; \
						docker image prune -a -f; \
					else \
						printf "Operação cancelada.\n"; \
					fi; \
					exit 0; \
					;; \
				3) \
					printf "Operação cancelada.\n"; \
					exit 0; \
					;; \
				*) \
					printf "$(RED)Opção inválida. Tente novamente.$(NC)\n"; \
					;; \
			esac; \
		done \
	'

env-check:
	@printf "$(CYAN)Valores lidos do arquivo $(ENV_FILE):$(NC)\n"
	@printf "  PROJECT_NAME=%s\n" "$(PROJECT_NAME)"
	@printf "  LOCAL_UID=%s\n" "$(LOCAL_UID)"
	@printf "  LOCAL_GID=%s\n" "$(LOCAL_GID)"
	@printf "  DB=%s\n" "$(DB)"
	@printf "  DB_USER=%s\n" "$(DB_USER)"
	@printf "  DB_NAME=%s\n" "$(DB_NAME)"

rm-env:
	@echo "Se existir .devcontainer/.env.devcontainer.example e você quiser removê-lo, execute:" \
		&& echo "  rm .devcontainer/.env.devcontainer.example" || true

regen-env:
	@printf "$(CYAN)Regenerando .env.development...$(NC)\n"
	@if [ -f "$(ENV_FILE)" ]; then \
		printf "$(YELLOW)Removendo $(ENV_FILE)...$(NC)\n"; \
		rm -f "$(ENV_FILE)"; \
	fi; \
	if [ "$$MAKE_INTERACTIVE" = "1" ]; then \
		printf "$(CYAN)Modo interativo: iniciando container para prompts...$(NC)\n"; \
		$(DOCKER) run --rm -e INTERACTIVE_ENV=1 -it $(APP_SERVICE_NAME) bash; \
	else \
		printf "$(CYAN)Subindo containers para gerar novo env (não-interativo)...$(NC)\n"; \
		$(DOCKER) up --build -d || true; \
		printf "$(GREEN)Regeneração finalizada.$(NC)\n"; \
	fi
