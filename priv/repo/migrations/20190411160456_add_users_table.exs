defmodule BadEx.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def change do
    create table("users") do
      add :name, :string, null: false
      add :email, :string
      add :avatar, :string
      add :address, :text
      add :admin, :boolean
      add :additional_info, :text
      timestamps(inserted_at: :created_at)
    end
  end
end
