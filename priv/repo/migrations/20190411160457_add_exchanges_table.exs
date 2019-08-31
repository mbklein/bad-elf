defmodule BadEx.Repo.Migrations.AddExchangesTable do
  use Ecto.Migration

  def change do
    create table("exchanges") do
      add :name, :string
      add :description, :text
      add :deadline, :date
      add :owner_id, :integer, null: false
      add :invite_code, :string
      add :closed, :boolean
      timestamps(inserted_at: :created_at)
    end
  end
end
