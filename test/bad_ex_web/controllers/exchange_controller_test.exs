defmodule BadExWeb.ExchangeControllerTest do
  use BadExWeb.ConnCase

  alias BadEx.App

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:exchange) do
    {:ok, exchange} = App.create_exchange(@create_attrs)
    exchange
  end

  describe "index" do
    test "lists all exchanges", %{conn: conn} do
      conn = get(conn, Routes.exchange_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Exchanges"
    end
  end

  describe "new exchange" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.exchange_path(conn, :new))
      assert html_response(conn, 200) =~ "New Exchange"
    end
  end

  describe "create exchange" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.exchange_path(conn, :create), exchange: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.exchange_path(conn, :show, id)

      conn = get(conn, Routes.exchange_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Exchange"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.exchange_path(conn, :create), exchange: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Exchange"
    end
  end

  describe "edit exchange" do
    setup [:create_exchange]

    test "renders form for editing chosen exchange", %{conn: conn, exchange: exchange} do
      conn = get(conn, Routes.exchange_path(conn, :edit, exchange))
      assert html_response(conn, 200) =~ "Edit Exchange"
    end
  end

  describe "update exchange" do
    setup [:create_exchange]

    test "redirects when data is valid", %{conn: conn, exchange: exchange} do
      conn = put(conn, Routes.exchange_path(conn, :update, exchange), exchange: @update_attrs)
      assert redirected_to(conn) == Routes.exchange_path(conn, :show, exchange)

      conn = get(conn, Routes.exchange_path(conn, :show, exchange))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, exchange: exchange} do
      conn = put(conn, Routes.exchange_path(conn, :update, exchange), exchange: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Exchange"
    end
  end

  describe "delete exchange" do
    setup [:create_exchange]

    test "deletes chosen exchange", %{conn: conn, exchange: exchange} do
      conn = delete(conn, Routes.exchange_path(conn, :delete, exchange))
      assert redirected_to(conn) == Routes.exchange_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.exchange_path(conn, :show, exchange))
      end
    end
  end

  defp create_exchange(_) do
    exchange = fixture(:exchange)
    {:ok, exchange: exchange}
  end
end
