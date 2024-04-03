# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :betting_system,
  ecto_repos: [BettingSystem.Repo]

# Configures the endpoint
config :betting_system, BettingSystemWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: BettingSystemWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: BettingSystem.PubSub,
  live_view: [signing_salt: "fy0l+YBs"]

config :tailwind,
  version: "3.3.3",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :swoosh, :api_client, Swoosh.ApiClient.Finch

config :betting_system, BettingSystem.Mailer, adapter: Swoosh.Adapters.Local

# config :betting_system, BettingSystem.Mailer, adapter: Swoosh.Adapters.Local

# # Swoosh API client is needed for adapters other than SMTP.
# config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.12.18",
  default: [
    args: ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
