# Latest version of Erlang-based Elixir installation: https://hub.docker.com/_/elixir/
FROM hexpm/elixir:1.13.4-erlang-25.1.2-debian-bullseye-20221004-slim

# Create and set home directory
ENV HOME /opt/car_pooling
WORKDIR $HOME

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Configure required environment
ENV MIX_ENV=prod

# Set and expose PORT environmental variable
ENV PORT=9091
EXPOSE $PORT

# Copy all application files
COPY . .

# Compile the entire project
RUN mix prod.redeploy

# Run Ecto migrations and Phoenix server as an initial command
CMD mix phx.server
