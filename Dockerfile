# Stage 1: Runtime =============================================================
# The minimal package dependencies required to run the app in the release image:

# Use the official Ruby 3.0.2 Slim Buster image as base:
FROM ruby:3.0.2-slim-buster

# We'll set MALLOC_ARENA_MAX for optimization purposes & prevent memory bloat
# https://www.speedshop.co/2017/12/04/malloc-doubles-ruby-memory.html
ENV MALLOC_ARENA_MAX="2"

# Install the app build system dependency packages:
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    build-essential \
    git

# Receive the developer user's UID and USER:
ARG DEVELOPER_UID=1000
ARG DEVELOPER_USERNAME=you

# Replicate the developer user in the development image:
RUN addgroup --gid ${DEVELOPER_UID} ${DEVELOPER_USERNAME} \
 ;  useradd -r -m -u ${DEVELOPER_UID} --gid ${DEVELOPER_UID} \
    --shell /bin/bash -c "Developer User,,," ${DEVELOPER_USERNAME}

 # Ensure the developer user's home directory and app path are owned by him/her:
# (A workaround to a side effect of setting WORKDIR before creating the user)
RUN userhome=$(eval echo ~${DEVELOPER_USERNAME}) \
 && chown -R ${DEVELOPER_USERNAME}:${DEVELOPER_USERNAME} $userhome \
 && mkdir -p /workspaces/ashby \
 && chown -R ${DEVELOPER_USERNAME}:${DEVELOPER_USERNAME} /workspaces/ashby

# Set the app path as the working directory:
WORKDIR /workspaces/ashby

# Change to the developer user:
USER ${DEVELOPER_USERNAME}

# Copy the project's Gemfile and Gemfile.lock files:
COPY --chown=${DEVELOPER_USERNAME} Gemfile* /workspaces/ashby/

# Install the gems in the Gemfile, except for the ones in the "development"
# group, which shouldn't be required in order to  run the tests with the leanest
# Docker image possible:
RUN bundle install --jobs=4 --retry=3

# Receive the developer username again, as ARGS won't persist between stages on
# non-buildkit builds:
ARG DEVELOPER_USERNAME=you

# Change to root user to install the development packages:
USER root

# Install sudo, along with any other tool required at development phase:
RUN apt-get install -y --no-install-recommends \
  # Adding bash autocompletion as git without autocomplete is a pain...
  bash-completion \
  # gpg & gpgconf is used to get Git Commit GPG Signatures working inside the
  # VSCode devcontainer:
  gpg \
  openssh-client \
  # Para esperar a que el servicio de minio (u otros) esté disponible:
  netcat \
  # /proc file system utilities: (watch, ps):
  procps \
  # Vim will be used to edit files when inside the container (git, etc):
  vim \
  # Sudo will be used to install/configure system stuff if needed during dev:
  sudo

# Add the developer user to the sudoers list:
RUN echo "${DEVELOPER_USERNAME} ALL=(ALL) NOPASSWD:ALL" | tee "/etc/sudoers.d/${DEVELOPER_USERNAME}"

# Persist the bash history between runs
# - See https://code.visualstudio.com/docs/remote/containers-advanced#_persist-bash-history-between-runs
RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/command-history/.bash_history" \
 && mkdir /command-history \
 && touch /command-history/.bash_history \
 && chown -R ${DEVELOPER_USERNAME} /command-history \
 && echo $SNIPPET >> "/home/${DEVELOPER_USERNAME}/.bashrc"

 # Create the extensions directories:
RUN mkdir -p \
  /home/${DEVELOPER_USERNAME}/.vscode-server/extensions \
  /home/${DEVELOPER_USERNAME}/.vscode-server-insiders/extensions \
 && chown -R ${DEVELOPER_USERNAME} \
  /home/${DEVELOPER_USERNAME}/.vscode-server \
  /home/${DEVELOPER_USERNAME}/.vscode-server-insiders

# Change back to the developer user:
USER ${DEVELOPER_USERNAME}
