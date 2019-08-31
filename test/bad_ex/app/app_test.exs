defmodule BadEx.AppTest do
  use BadEx.DataCase

  alias BadEx.App

  describe "users" do
    alias BadEx.App.User

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> App.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert App.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert App.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = App.create_user(@valid_attrs)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = App.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = App.update_user(user, @update_attrs)
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = App.update_user(user, @invalid_attrs)
      assert user == App.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = App.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> App.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = App.change_user(user)
    end
  end

  describe "exchanges" do
    alias BadEx.App.Exchange

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def exchange_fixture(attrs \\ %{}) do
      {:ok, exchange} =
        attrs
        |> Enum.into(@valid_attrs)
        |> App.create_exchange()

      exchange
    end

    test "list_exchanges/0 returns all exchanges" do
      exchange = exchange_fixture()
      assert App.list_exchanges() == [exchange]
    end

    test "get_exchange!/1 returns the exchange with given id" do
      exchange = exchange_fixture()
      assert App.get_exchange!(exchange.id) == exchange
    end

    test "create_exchange/1 with valid data creates a exchange" do
      assert {:ok, %Exchange{} = exchange} = App.create_exchange(@valid_attrs)
    end

    test "create_exchange/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = App.create_exchange(@invalid_attrs)
    end

    test "update_exchange/2 with valid data updates the exchange" do
      exchange = exchange_fixture()
      assert {:ok, %Exchange{} = exchange} = App.update_exchange(exchange, @update_attrs)
    end

    test "update_exchange/2 with invalid data returns error changeset" do
      exchange = exchange_fixture()
      assert {:error, %Ecto.Changeset{}} = App.update_exchange(exchange, @invalid_attrs)
      assert exchange == App.get_exchange!(exchange.id)
    end

    test "delete_exchange/1 deletes the exchange" do
      exchange = exchange_fixture()
      assert {:ok, %Exchange{}} = App.delete_exchange(exchange)
      assert_raise Ecto.NoResultsError, fn -> App.get_exchange!(exchange.id) end
    end

    test "change_exchange/1 returns a exchange changeset" do
      exchange = exchange_fixture()
      assert %Ecto.Changeset{} = App.change_exchange(exchange)
    end
  end

  describe "assignments" do
    alias BadEx.App.Assignment

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def assignment_fixture(attrs \\ %{}) do
      {:ok, assignment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> App.create_assignment()

      assignment
    end

    test "list_assignments/0 returns all assignments" do
      assignment = assignment_fixture()
      assert App.list_assignments() == [assignment]
    end

    test "get_assignment!/1 returns the assignment with given id" do
      assignment = assignment_fixture()
      assert App.get_assignment!(assignment.id) == assignment
    end

    test "create_assignment/1 with valid data creates a assignment" do
      assert {:ok, %Assignment{} = assignment} = App.create_assignment(@valid_attrs)
    end

    test "create_assignment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = App.create_assignment(@invalid_attrs)
    end

    test "update_assignment/2 with valid data updates the assignment" do
      assignment = assignment_fixture()
      assert {:ok, %Assignment{} = assignment} = App.update_assignment(assignment, @update_attrs)
    end

    test "update_assignment/2 with invalid data returns error changeset" do
      assignment = assignment_fixture()
      assert {:error, %Ecto.Changeset{}} = App.update_assignment(assignment, @invalid_attrs)
      assert assignment == App.get_assignment!(assignment.id)
    end

    test "delete_assignment/1 deletes the assignment" do
      assignment = assignment_fixture()
      assert {:ok, %Assignment{}} = App.delete_assignment(assignment)
      assert_raise Ecto.NoResultsError, fn -> App.get_assignment!(assignment.id) end
    end

    test "change_assignment/1 returns a assignment changeset" do
      assignment = assignment_fixture()
      assert %Ecto.Changeset{} = App.change_assignment(assignment)
    end
  end
end
