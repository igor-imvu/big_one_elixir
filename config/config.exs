# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :timelinex,
  ecto_repos: [Timelinex.Repo]

# Configures the endpoint
config :timelinex, Timelinex.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Kl3zj5tW/QYDXS+kz+07sGT5jKbLycXxZTGJ/TxqWeryIxQBvnCdT6X9/lBxHBvq",
  render_errors: [view: Timelinex.ErrorView, accepts: ~w(json)],
  pubsub: [name: Timelinex.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
