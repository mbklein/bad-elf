defmodule BadExWeb.Resolvers.Data do
  alias BadEx.Repo
  import Ecto.Query

  def thing_resolver(queryable) do
    fn _, %{id: id}, _ ->
      {:ok,
       from(q in queryable, where: q.id == ^id)
       |> Repo.one()}
    end
  end

  def list_of_things_resolver(queryable) do
    fn _, args, _ ->
      query =
        args
        |> Enum.reduce(queryable, fn
          {:start, start}, query ->
            from(q in query, where: q.id >= ^start)

          {:limit, limit}, query ->
            from(q in query, limit: ^limit)

          _, query ->
            query
        end)

      {:ok, query |> order_by(:id) |> Repo.all()}
    end
  end

  # Dataloader

  def datasource do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _) do
    queryable
  end
end
