defmodule BadExWeb.AssignmentControllerTest do
  use BadExWeb.ConnCase

  alias BadEx.App

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:assignment) do
    {:ok, assignment} = App.create_assignment(@create_attrs)
    assignment
  end

  describe "index" do
    test "lists all assignments", %{conn: conn} do
      conn = get(conn, Routes.assignment_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Assignments"
    end
  end

  describe "new assignment" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.assignment_path(conn, :new))
      assert html_response(conn, 200) =~ "New Assignment"
    end
  end

  describe "create assignment" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.assignment_path(conn, :create), assignment: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.assignment_path(conn, :show, id)

      conn = get(conn, Routes.assignment_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Assignment"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.assignment_path(conn, :create), assignment: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Assignment"
    end
  end

  describe "edit assignment" do
    setup [:create_assignment]

    test "renders form for editing chosen assignment", %{conn: conn, assignment: assignment} do
      conn = get(conn, Routes.assignment_path(conn, :edit, assignment))
      assert html_response(conn, 200) =~ "Edit Assignment"
    end
  end

  describe "update assignment" do
    setup [:create_assignment]

    test "redirects when data is valid", %{conn: conn, assignment: assignment} do
      conn = put(conn, Routes.assignment_path(conn, :update, assignment), assignment: @update_attrs)
      assert redirected_to(conn) == Routes.assignment_path(conn, :show, assignment)

      conn = get(conn, Routes.assignment_path(conn, :show, assignment))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, assignment: assignment} do
      conn = put(conn, Routes.assignment_path(conn, :update, assignment), assignment: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Assignment"
    end
  end

  describe "delete assignment" do
    setup [:create_assignment]

    test "deletes chosen assignment", %{conn: conn, assignment: assignment} do
      conn = delete(conn, Routes.assignment_path(conn, :delete, assignment))
      assert redirected_to(conn) == Routes.assignment_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.assignment_path(conn, :show, assignment))
      end
    end
  end

  defp create_assignment(_) do
    assignment = fixture(:assignment)
    {:ok, assignment: assignment}
  end
end
