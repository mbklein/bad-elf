defmodule BadEx.App do
  @moduledoc """
  The App context.
  """

  import Ecto.Query, warn: false
  alias BadEx.Repo

  alias BadEx.App.User

  defmacro __using__(opts) do
    [
      if opts[:helpers] do
        quote do
          alias BadEx.Repo
          alias BadEx.App.{AssignmentList, Assignment, Exchange, User}
          import BadEx.App.{Queries}
          import Ecto.Query
          true
        end
      end
    ]
    |> Enum.reject(&is_nil(&1))
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  alias BadEx.App.Exchange

  @doc """
  Returns the list of exchanges.

  ## Examples

      iex> list_exchanges()
      [%Exchange{}, ...]

  """
  def list_exchanges do
    Repo.all(Exchange)
  end

  @doc """
  Gets a single exchange.

  Raises `Ecto.NoResultsError` if the Exchange does not exist.

  ## Examples

      iex> get_exchange!(123)
      %Exchange{}

      iex> get_exchange!(456)
      ** (Ecto.NoResultsError)

  """
  def get_exchange!(id), do: Repo.get!(Exchange, id)

  @doc """
  Creates a exchange.

  ## Examples

      iex> create_exchange(%{field: value})
      {:ok, %Exchange{}}

      iex> create_exchange(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_exchange(attrs \\ %{}) do
    %Exchange{}
    |> Exchange.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a exchange.

  ## Examples

      iex> update_exchange(exchange, %{field: new_value})
      {:ok, %Exchange{}}

      iex> update_exchange(exchange, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_exchange(%Exchange{} = exchange, attrs) do
    exchange
    |> Exchange.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Exchange.

  ## Examples

      iex> delete_exchange(exchange)
      {:ok, %Exchange{}}

      iex> delete_exchange(exchange)
      {:error, %Ecto.Changeset{}}

  """
  def delete_exchange(%Exchange{} = exchange) do
    Repo.delete(exchange)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking exchange changes.

  ## Examples

      iex> change_exchange(exchange)
      %Ecto.Changeset{source: %Exchange{}}

  """
  def change_exchange(%Exchange{} = exchange) do
    Exchange.changeset(exchange, %{})
  end

  alias BadEx.App.Assignment

  @doc """
  Returns the list of assignments.

  ## Examples

      iex> list_assignments()
      [%Assignment{}, ...]

  """
  def list_assignments do
    Repo.all(Assignment)
  end

  @doc """
  Gets a single assignment.

  Raises `Ecto.NoResultsError` if the Assignment does not exist.

  ## Examples

      iex> get_assignment!(123)
      %Assignment{}

      iex> get_assignment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_assignment!(id), do: Repo.get!(Assignment, id)

  @doc """
  Creates a assignment.

  ## Examples

      iex> create_assignment(%{field: value})
      {:ok, %Assignment{}}

      iex> create_assignment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_assignment(attrs \\ %{}) do
    %Assignment{}
    |> Assignment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a assignment.

  ## Examples

      iex> update_assignment(assignment, %{field: new_value})
      {:ok, %Assignment{}}

      iex> update_assignment(assignment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_assignment(%Assignment{} = assignment, attrs) do
    assignment
    |> Assignment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Assignment.

  ## Examples

      iex> delete_assignment(assignment)
      {:ok, %Assignment{}}

      iex> delete_assignment(assignment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_assignment(%Assignment{} = assignment) do
    Repo.delete(assignment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking assignment changes.

  ## Examples

      iex> change_assignment(assignment)
      %Ecto.Changeset{source: %Assignment{}}

  """
  def change_assignment(%Assignment{} = assignment) do
    Assignment.changeset(assignment, %{})
  end
end
