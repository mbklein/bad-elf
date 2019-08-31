defmodule BadEx.App.Queries do
  import Ecto.Query

  def with_users(query) do
    query |> preload([:users, assignments: [[elf: :exclusions], :recipient]])
  end
end
