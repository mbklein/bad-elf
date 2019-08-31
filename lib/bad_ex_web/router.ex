defmodule BadExWeb.Router do
  use BadExWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api" do
    pipe_through :api

    forward "/graphql", Absinthe.Plug, schema: BadExWeb.Schema.Schema

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: BadExWeb.Schema.Schema,
      socket: BadExWeb.UserSocket

    forward "/", Plug.Static,
      at: "/",
      from: {:bad_ex, "priv/static"},
      only: ["voyager"],
      headers: %{"content-type" => "text/html"}
  end

  scope "/", BadExWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/users", UserController
    resources "/exchanges", ExchangeController
  end

  scope "/auth", BadExWeb do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", BadExWeb do
  #   pipe_through :api
  # end
end
