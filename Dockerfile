FROM bitwalker/alpine-elixir-phoenix:latest

RUN apk update && apk upgrade && apk add postgresql=9.6.5-r0

# Set exposed ports
EXPOSE 5000
ENV PORT=5000 MIX_ENV=prod

# Cache elixir deps
ADD mix.exs mix.lock ./
# Copy up here because Guardian needs config file
ADD . .
RUN mix do deps.get, deps.compile

# Same with npm deps
# ADD package.json package.json
# RUN npm install

# ADD . .

# Run frontend build, compile, and digest assets
RUN mix do compile, phx.digest

USER default

CMD ["mix", "phx.server"]
