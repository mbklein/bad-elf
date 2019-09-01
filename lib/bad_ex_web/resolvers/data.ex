defmodule BadExWeb.Resolvers.Data do
  alias BadEx.App.{Assignment, Exchange, User}
  alias BadEx.Repo
  import Ecto.Query

  defp user_exchanges(user_id) do
    owned = from(ex in Exchange, where: ex.owner_id == ^user_id)

    participating =
      from(ex in Exchange,
        join: a in Assignment,
        where: ex.id == a.exchange_id and a.elf_id == ^user_id
      )

    from ex in subquery(union(owned, ^participating)), order_by: ex.id
  end

  def exchange(_, %{id: id}, %{context: %{user: user}}) do
    {:ok,
     from(ex in user_exchanges(user.id),
       where: ex.id == ^id
     )
     |> Repo.one()}
  end

  def exchange(_, _, _) do
    {:error, %{message: "Unauthorized", status: 401}}
  end

  def exchanges(_, _, %{context: %{user: user}}) do
    {:ok,
     from(ex in from(user_exchanges(user.id)), order_by: ex.id)
     |> Repo.all()}
  end

  def exchanges(_, _, _) do
    {:error, %{message: "Unauthorized", status: 401}}
  end

  def admin_resolver(queryable) do
    fn
      _, %{id: id}, %{context: %{user: %User{admin: true}}} ->
        {:ok,
         from(q in queryable, where: q.id == ^id)
         |> Repo.one()}

      _, args, %{context: %{user: %User{admin: true}}} ->
        {:ok,
         args
         |> Enum.reduce(queryable, fn
           {:start, start}, query ->
             from(q in query, where: q.id >= ^start)

           {:limit, limit}, query ->
             from(q in query, limit: ^limit)

           _, query ->
             query
         end)
         |> order_by(:id)
         |> Repo.all()}

      _, _, _ ->
        {:error, %{message: "Unauthorized", status: 401}}
    end
  end

  # Dataloader

  def datasource do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _) do
    from q in queryable, order_by: [asc: q.id]
  end
end
