defmodule BadEx.App.Exchange do
  use Ecto.Schema
  import Ecto.Changeset
  alias BadEx.App.{User, Assignment}

  schema "exchanges" do
    field :closed, :boolean, default: false
    field :deadline, :date
    field :description, :string
    field :invite_code, :string
    field :name, :string
    field :owner_id, :integer

    timestamps(inserted_at: :created_at)

    has_many :assignments, Assignment

    many_to_many :users, User,
      join_through: Assignment,
      join_keys: [exchange_id: :id, elf_id: :id]
  end

  @doc false
  def changeset(exchange, attrs) do
    exchange
    |> cast(attrs, [:name, :description, :deadline, :owner_id, :invite_code, :closed])
    |> validate_required([:name, :description, :deadline, :owner_id, :invite_code, :closed])
  end
end
