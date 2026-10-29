FROM hexpm/elixir:1.17.3-erlang-27.1-debian-bookworm-20240926 AS build
RUN apt-get update && apt-get install -y --no-install-recommends build-essential git && rm -rf /var/lib/apt/lists/*
WORKDIR /app
RUN mix local.hex --force && mix local.rebar --force
ENV MIX_ENV=prod
COPY mix.exs ./
RUN mix deps.get --only prod
COPY config config
COPY lib lib
COPY priv priv
RUN mix compile
RUN mix release
FROM debian:bookworm-slim AS runtime
RUN apt-get update && apt-get install -y --no-install-recommends libstdc++6 openssl libncurses6 locales ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /app
ENV LANG=C.UTF-8
COPY --from=build /app/_build/prod/rel/pulse_ops ./
ENV HOME=/app
CMD ["bin/pulse_ops", "start"]
