defmodule BadEx.App.AssignmentList do
  alias BadEx.App.Assignment

  @max_shuffles 100

  def valid?(assignments) do
    assignments |> Enum.all?(&Assignment.valid?(&1))
  end

  defp reassign([assignment | assignments], [elf | [recipient | rest]]) do
    [
      assignment
      |> Assignment.assign(elf: elf, recipient: recipient)
      | reassign(elf, assignments, [recipient | rest])
    ]
  end

  defp reassign(recipient, [assignment], [elf]) do
    [assignment |> Assignment.assign(elf: elf, recipient: recipient)]
  end

  defp reassign(first, [assignment | assignments], [elf | [recipient | rest]]) do
    [
      assignment
      |> Assignment.assign(elf: elf, recipient: recipient)
      | reassign(first, assignments, [recipient | rest])
    ]
  end

  def shuffle_assignments(assignments, attempt \\ 1)

  def shuffle_assignments(_, attempt) when attempt > @max_shuffles do
    {:error, attempt, "Maximum number of attempts reached"}
  end

  def shuffle_assignments(assignments, attempt) do
    new_order = Enum.shuffle(Enum.map(assignments, & &1.elf))
    result = reassign(assignments, new_order)

    if valid?(result),
      do: {:ok, attempt, result},
      else: shuffle_assignments(assignments, attempt + 1)
  end

  def unassign_all(assignments) do
    Enum.map(assignments, &Assignment.assign(&1, recipient: &1.recipient))
  end

  def inspect(assignments) do
    IO.puts("#{Enum.count(assignments)}:")
    Enum.each(assignments, &IO.puts("#{&1.elf.name} -> #{&1.recipient.name}"))
  end
end
