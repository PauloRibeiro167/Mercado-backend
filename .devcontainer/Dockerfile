FROM ruby:3.4.5-slim

# =============================================================================
# Configurações iniciais do ambiente
# =============================================================================

# Configura o frontend do debconf para não interativo, evitando prompts durante o build
ENV DEBIAN_FRONTEND=noninteractive

# Desabilita traduções do APT para acelerar as instalações
RUN echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/99disable-translations

# =============================================================================
# Instalar dependências do sistema
# =============================================================================

# Instala dependências básicas para Rails e desenvolvimento
RUN apt-get update && \
  apt-get install -y --no-install-recommends --no-install-suggests \
  build-essential \
  libssl-dev \
  libreadline-dev \
  zlib1g-dev \
  libyaml-dev \
  libffi-dev \
  libgmp-dev \
  libpq-dev \
  nodejs \
  npm \
  git \
  curl \
  locales \
  graphviz \
  gosu \
  net-tools \
  lsof \
  && echo "pt_BR.UTF-8 UTF-8" >> /etc/locale.gen \
  && locale-gen pt_BR.UTF-8 \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# =============================================================================
# Configurar locale e variáveis de ambiente
# =============================================================================

ENV LANG=pt_BR.UTF-8
ENV LANGUAGE=pt_BR:pt
ENV LC_ALL=pt_BR.UTF-8

# =============================================================================
# Instalar Bundler para gerenciamento de gems
# =============================================================================

RUN gem install bundler

# =============================================================================
# Preparar projeto e instalar dependências Ruby
# =============================================================================

# Criar diretório do projeto
RUN mkdir -p /workspaces/backend

# Definir diretório de trabalho
WORKDIR /workspaces/backend

# Copiar arquivos de dependências
COPY api/Gemfile api/Gemfile.lock ./

# Atualizar dependências das gems
RUN gem update

# Instalar dependências do projeto
RUN bundle install

# =============================================================================
# Configurar PATH para incluir binários das gems
# =============================================================================

ENV PATH="/usr/local/bundle/bin:${PATH}"

# =============================================================================
# Configurar usuário não-root para desenvolvimento
# =============================================================================

# Argumentos de build para UID/GID do usuário
ARG LOCAL_UID=1000
ARG LOCAL_GID=1000

# Criar usuário não-root se não existir
RUN \
  EXISTING_GROUP=$(getent group | awk -F: -v gid="$LOCAL_GID" '$3==gid{print $1}'); \
  if [ -z "$EXISTING_GROUP" ]; then groupadd -g "$LOCAL_GID" devgroup; else echo "Grupo $EXISTING_GROUP já existe para GID $LOCAL_GID"; fi; \
  EXISTING_USER=$(getent passwd | awk -F: -v uid="$LOCAL_UID" '$3==uid{print $1}'); \
  if [ -z "$EXISTING_USER" ]; then useradd -m -u "$LOCAL_UID" -g "$LOCAL_GID" -s /bin/bash dev || true; else echo "Usuário $EXISTING_USER já existe para UID $LOCAL_UID"; fi

# =============================================================================
# Configurar entrypoint
# =============================================================================

# Copiar script de entrypoint que cria usuário em tempo de execução
COPY .devcontainer/db_setup/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# =============================================================================
# Expor portas da aplicação
# =============================================================================

EXPOSE 3000 3001

# =============================================================================
# Comando de execução
# =============================================================================

# Entry point: cria usuário com UID/GID do host e executa o comando
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["bin/dev"]
