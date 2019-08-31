defmodule BadEx.App.User do
  use Ecto.Schema
  import Ecto.{Changeset, Query}
  alias BadEx.App.{Assignment, Exchange, User}
  alias Ueberauth.Auth
  alias Ueberauth.Auth.Info

  schema "users" do
    field :additional_info, :string
    field :address, :string
    field :admin, :boolean, default: false
    field :avatar, :string
    field :email, :string
    field :name, :string

    timestamps(inserted_at: :created_at)

    has_many :assignments, Assignment, foreign_key: :elf_id

    many_to_many :exclusions, User,
      join_through: "exclusions",
      join_keys: [source_id: :id, target_id: :id],
      on_replace: :delete

    many_to_many :exchanges, Exchange,
      join_through: Assignment,
      join_keys: [elf_id: :id, exchange_id: :id]
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :avatar, :address, :admin, :additional_info])
    |> validate_required([:name, :email])
  end

  def from_auth(%Auth{info: %Info{name: name, email: email, image: avatar}}) do
    try do
      {
        :ok,
        case from(u in User, where: u.email == ^email) |> BadEx.Repo.one() do
          nil -> BadEx.App.create_user(%{name: name, email: email, avatar: avatar})
          user -> user
        end
      }
    rescue
      e -> {:error, e.message}
    end
  end
end
