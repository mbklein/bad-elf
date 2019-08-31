defmodule BadEx.Repo.Migrations.AddAssignmentsTable do
  use Ecto.Migration

  def change do
    create table("assignments") do
      add :exchange_id, :integer, null: false
      add :elf_id, :integer, null: false
      add :recipient_id, :integer
      timestamps(inserted_at: :created_at)
    end
  end
end
