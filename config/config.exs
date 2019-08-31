# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :bad_ex,
  ecto_repos: [BadEx.Repo]

# Configures the endpoint
config :bad_ex, BadExWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "BuaF1IS4VQh3YfLT01LJheBxmZp+r5mcrHpt852N137bYtjd8XsrrwHYbHIph8NX",
  render_errors: [view: BadExWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: BadEx.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ueberauth, Ueberauth,
  providers: [
    facebook:
      {Ueberauth.Strategy.Facebook,
       [
         default_scope: "email",
         callback_url: System.get_env("FACEBOOK_CALLBACK_URL")
       ]}
  ]

config :ueberauth, Ueberauth.Strategy.Facebook.OAuth,
  client_id: System.get_env("FACEBOOK_KEY"),
  client_secret: System.get_env("FACEBOOK_SECRET")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
