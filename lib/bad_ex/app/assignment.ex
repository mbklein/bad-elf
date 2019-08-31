defmodule BadEx.App.Assignment do
  use Ecto.Schema
  import Ecto.Changeset
  alias BadEx.App.{Exchange, User}

  schema "assignments" do
    belongs_to :exchange, Exchange
    belongs_to :elf, User
    belongs_to :recipient, User
    timestamps(inserted_at: :created_at)
  end

  @doc false
  def changeset(assignment, attrs) do
    assignment
    |> cast(attrs, [])
    |> validate_required([])
  end

  @spec valid?(assignment :: %__MODULE__{}) :: boolean()
  def valid?(assignment) do
    unless Ecto.assoc_loaded?(assignment.elf) && Ecto.assoc_loaded?(assignment.elf.exclusions),
      do:
        raise(ArgumentError,
          message: "Exclusions not preloaded on %BadEx.Assignment{id: #{assignment.id}}"
        )

    assignment.recipient_id not in Enum.map(assignment.elf.exclusions, & &1.id)
  end

  def assign(assignment, elf: elf, recipient: recipient) do
    %__MODULE__{
      assignment
      | elf: elf,
        elf_id: id_or_nil(elf),
        recipient: recipient,
        recipient_id: id_or_nil(recipient)
    }
  end

  defp id_or_nil(user) do
    case user do
      nil -> nil
      user -> user.id
    end
  end
end
