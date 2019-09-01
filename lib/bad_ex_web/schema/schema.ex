defmodule BadExWeb.Schema.Schema do
  @moduledoc """
  Absinthe Schema for BadExWeb

  """
  use Absinthe.Ecto, repo: BadEx.Repo
  use Absinthe.Schema
  import_types(Absinthe.Type.Custom)

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]
  alias BadExWeb.Resolvers.Data

  query do
    @desc "Fetch the current user"
    field :current_user, :user do
      resolve(fn _, _, %{context: %{user: user}} ->
        {:ok, user}
      end)
    end

    @desc """
    Fetch a single exchange that the current user owns and/or
    is participating in
    """
    field :user_exchange, :exchange do
      arg(:id, non_null(:id))
      resolve(&Data.exchange/3)
    end

    @desc """
    Fetch all exchanges that the current user owns and/or
    is participating in
    """
    field :user_exchanges, list_of(:exchange) do
      arg(:start, :integer)
      arg(:limit, :integer)
      resolve(&Data.exchanges/3)
    end

    @desc "Fetch a single exchange (admins only)"
    field :exchange, :exchange do
      arg(:id, non_null(:id))
      resolve(Data.admin_resolver(BadEx.App.Exchange))
    end

    @desc "Fetch all exchanges (admins only)"
    field :exchanges, list_of(:exchange) do
      arg(:start, :integer)
      arg(:limit, :integer)
      resolve(Data.admin_resolver(BadEx.App.Exchange))
    end

    @desc "Fetch a single user (admins only)"
    field :user, :user do
      arg(:id, non_null(:id))
      resolve(Data.admin_resolver(BadEx.App.User))
    end

    @desc "Fetch all users (admins only)"
    field :users, list_of(:user) do
      arg(:start, :integer)
      arg(:limit, :integer)
      resolve(Data.admin_resolver(BadEx.App.User))
    end
  end

  object :exchange do
    field :id, :integer
    field :closed, :boolean
    field :deadline, :naive_datetime
    field :description, :string
    field :invite_code, :string
    field :name, non_null(:string)
    field :owner, :user, resolve: dataloader(Data)
    field :users, list_of(:user), resolve: dataloader(Data)
    field :assignments, list_of(:assignment), resolve: dataloader(Data)
  end

  object :user do
    field :id, :integer
    field :additional_info, :string
    field :address, :string
    field :admin, :boolean
    field :avatar, :string
    field :email, non_null(:string)
    field :name, non_null(:string)
    field :assignments, list_of(:assignment), resolve: dataloader(Data)
    field :exchanges, list_of(:exchange), resolve: dataloader(Data)
  end

  object :assignment do
    field :exchange, :exchange, resolve: dataloader(Data)
    field :elf, :user, resolve: dataloader(Data)
    field :recipient, :user, resolve: dataloader(Data)
  end

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(Data, Data.datasource())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
