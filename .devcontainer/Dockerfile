FROM ruby:3.4.5-slim

# Configura o frontend do debconf para não interativo, evitando prompts durante o build
ENV DEBIAN_FRONTEND=noninteractive

# Usa apenas desativação de traduções do APT para acelerar
RUN echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/99disable-translations

# Atualiza e instala dependências
# Instala dependências básicas para Rails
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
  && echo "pt_BR.UTF-8 UTF-8" >> /etc/locale.gen \
  && locale-gen pt_BR.UTF-8 \
  && apt-get install -y --no-install-recommends net-tools lsof \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV LANG=pt_BR.UTF-8
ENV LANGUAGE=pt_BR:pt
ENV LC_ALL=pt_BR.UTF-8



# Instala bundler
RUN gem install bundler

# Instalar dependências do backend Rails
RUN mkdir -p /workspaces/backend
COPY api/Gemfile api/Gemfile.lock /workspaces/backend/
RUN cd /workspaces/backend && bundle install



# Configura o PATH
ENV PATH="/usr/local/bundle/bin:${PATH}"







# Build-time args: permitem criar usuário na imagem durante o build (opcional)
ARG LOCAL_UID=1000
ARG LOCAL_GID=1000

# Criar usuário não-root para possíveis operações (usuário padrão durante build)
# Se já existir um usuário/grupo com os mesmos IDs, usa-os; caso contrário cria.
RUN \
  EXISTING_GROUP=$(getent group | awk -F: -v gid="$LOCAL_GID" '$3==gid{print $1}'); \
  if [ -z "$EXISTING_GROUP" ]; then groupadd -g "$LOCAL_GID" devgroup; else echo "group $EXISTING_GROUP exists for GID $LOCAL_GID"; fi; \
  EXISTING_USER=$(getent passwd | awk -F: -v uid="$LOCAL_UID" '$3==uid{print $1}'); \
  if [ -z "$EXISTING_USER" ]; then useradd -m -u "$LOCAL_UID" -g "$LOCAL_GID" -s /bin/bash dev || true; else echo "user $EXISTING_USER exists for UID $LOCAL_UID"; fi



# Copiar entrypoint que criará um usuário em tempo de execução com o UID/GID do host
COPY .devcontainer/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh





EXPOSE 3000
EXPOSE 3001

WORKDIR /workspaces/backend

# Entry point: cria usuário com UID/GID do host (se fornecido via env) e executa o comando como esse usuário
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["rails", "server", "-b", "0.0.0.0"]
