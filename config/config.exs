# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :db_backuper, DbBackuperWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ce2y2heHSYYQS+T0vJp8dDXyKr+4SywiE7a86TSdY336Ocm/iB6yheFzZKh1uByd",
  render_errors: [view: DbBackuperWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: DbBackuper.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ex_aws,
  access_key_id: System.get_env("AWS_ACCESS_KEY"),
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
  region: System.get_env("AWS_REGION")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
