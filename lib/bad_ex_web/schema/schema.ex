defmodule BadExWeb.Schema.Schema do
  @moduledoc """
  Absinthe Schema for BadExWeb

  """
  use Absinthe.Ecto, repo: BadEx.Repo
  use Absinthe.Schema
  import_types(Absinthe.Type.Custom)

  import Absinthe.Ecto, only: [assoc: 1]
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]
  alias BadExWeb.Resolvers.Data

  query do
    field :assignments, list_of(:assignment) do
      arg(:start, :integer)
      arg(:limit, :integer)
      resolve(Data.list_of_things_resolver(BadEx.App.Assignment))
    end

    field :exchange, :exchange do
      arg(:id, non_null(:id))
      resolve(Data.thing_resolver(BadEx.App.Exchange))
    end

    field :exchanges, list_of(:exchange) do
      arg(:start, :integer)
      arg(:limit, :integer)
      resolve(Data.list_of_things_resolver(BadEx.App.Exchange))
    end

    field :user, :user do
      arg(:id, non_null(:id))
      resolve(Data.thing_resolver(BadEx.App.User))
    end

    field :users, list_of(:user) do
      arg(:start, :integer)
      arg(:limit, :integer)
      resolve(Data.list_of_things_resolver(BadEx.App.User))
    end
  end

  object :assignment do
    field :exchange, :exchange, resolve: assoc(:exchange)
    field :elf, :user, resolve: assoc(:elf)
    field :recipient, :user, resolve: assoc(:recipient)
  end

  object :exchange do
    field :closed, :boolean
    field :deadline, :naive_datetime
    field :description, :string
    field :invite_code, :string
    field :name, non_null(:string)
    field :owner, :user, resolve: assoc(:owner)
    field :users, list_of(:user), resolve: assoc(:users)
    field :assignments, list_of(:assignment), resolve: dataloader(Data)
  end

  object :user do
    field :additional_info, :string
    field :address, :string
    field :admin, :boolean
    field :avatar, :string
    field :email, non_null(:string)
    field :name, non_null(:string)
    field :assignments, list_of(:assignment), resolve: assoc(:assignments)
    field :exchanges, list_of(:exchange), resolve: assoc(:exchanges)
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
