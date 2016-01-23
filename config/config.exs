# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :whisper, Whisper.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "JFsniS5Ehk8Ze3j0TweY4J8gwKCgWI8bd6tgdRayPykiYR7qDyeUnC5aXaAzUXau",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Whisper.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures Exq
config :exq,
  host: "127.0.0.1",
  port: 6379,
  namespace: "exq"

# Configures Mailgun
config :whisper,
  mailgun_domain: System.get_env("MAILGUN_DOMAIN"),
  mailgun_key: System.get_env("MAILGUN_KEY")

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
