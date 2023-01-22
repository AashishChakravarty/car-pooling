FROM elixir:latest

# Create and set home directory
ENV HOME /opt/car_pooling
WORKDIR $HOME

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Configure required environment
ENV MIX_ENV prod

# Set and expose PORT environmental variable
ENV PORT ${PORT:-9091}
EXPOSE $PORT

EXPOSE 9091

# Copy all application files
COPY . .

# Install all production dependencies
RUN mix deps.get --only prod

# Compile all dependencies
RUN mix deps.compile

# Compile the entire project
RUN mix compile

# Run Ecto migrations and Phoenix server as an initial command
CMD mix do ecto.migrate, phx.server
