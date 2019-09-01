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

  def sort([head | []], map) do
    [map |> Map.get(head.recipient_id)]
  end

  def sort([_ | tail], map) do
    with state <- sort(tail, map) do
      [map |> Map.get(List.first(state).recipient_id) | state]
    end
  end

  def sort(assignments) do
    case assignments |> Enum.any?(fn a -> a.recipient_id |> is_nil() end) do
      true ->
        assignments

      false ->
        map = assignments |> Enum.map(&{&1.elf_id, &1}) |> Enum.into(%{})
        sort(assignments, map) |> Enum.reverse()
    end
  end

  def unassign_all(assignments) do
    Enum.map(assignments, &Assignment.assign(&1, recipient: &1.recipient))
  end

  def inspect(assignments) do
    IO.puts("#{Enum.count(assignments)}:")

    assignments
    |> Enum.each(fn
      %{elf: elf, recipient_id: nil} -> IO.puts("#{elf.name} -> UNASSIGNED")
      %{elf: elf, recipient: recipient} -> IO.puts("#{elf.name} -> #{recipient.name}")
    end)
  end
end
