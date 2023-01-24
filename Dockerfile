# Latest version of Erlang-based Elixir installation: https://hub.docker.com/_/elixir/
FROM hexpm/elixir:1.13.4-erlang-25.1.2-debian-bullseye-20221004-slim AS build


# Create and set home directory
ENV HOME /opt/car_pooling
WORKDIR $HOME

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Configure required environment

ENV MIX_ENV test

# Set and expose PORT environmental variable
ENV PORT ${PORT:-9091}

EXPOSE $PORT

# Copy all application files
COPY . .

# Compile the entire project
RUN mix deps.get
RUN mix ecto.migrate
RUN mix phx.digest

# Run Ecto migrations and Phoenix server as an initial command
CMD mix phx.server 2>&1 > "/opt/car_pooling/logs/server.log"
