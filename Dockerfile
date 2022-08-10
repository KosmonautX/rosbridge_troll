FROM hexpm/elixir-arm64

# Build Args
ARG PHOENIX_VERSION=1.6.10

# Apt
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y apt-utils
RUN apt-get install -y build-essential
RUN apt-get install -y inotify-tools
RUN apt-get install -y cmake

# Phoenix
RUN mix local.hex --force
RUN mix archive.install --force hex phx_new #{PHOENIX_VERSION}
RUN mix local.rebar --force

# App Directory
ENV APP_HOME /phos
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

# App Port
EXPOSE 4000

# Default Command
CMD ["mix", "phx.server"]
