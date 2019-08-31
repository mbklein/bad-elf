defmodule BadEx.Repo.Migrations.AddExclusionsTable do
  use Ecto.Migration

  def change do
    create table("exclusions") do
      add :source_id, :integer, null: false
      add :target_id, :integer, null: false
    end
  end
end
