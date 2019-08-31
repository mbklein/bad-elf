defmodule BadExWeb.ExchangeController do
  use BadExWeb, :controller

  alias BadEx.App
  alias BadEx.App.Exchange

  def index(conn, _params) do
    exchanges = App.list_exchanges()
    render(conn, "index.html", exchanges: exchanges)
  end

  def new(conn, _params) do
    changeset = App.change_exchange(%Exchange{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"exchange" => exchange_params}) do
    case App.create_exchange(exchange_params) do
      {:ok, exchange} ->
        conn
        |> put_flash(:info, "Exchange created successfully.")
        |> redirect(to: Routes.exchange_path(conn, :show, exchange))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    exchange = App.get_exchange!(id)
    render(conn, "show.html", exchange: exchange)
  end

  def edit(conn, %{"id" => id}) do
    exchange = App.get_exchange!(id)
    changeset = App.change_exchange(exchange)
    render(conn, "edit.html", exchange: exchange, changeset: changeset)
  end

  def update(conn, %{"id" => id, "exchange" => exchange_params}) do
    exchange = App.get_exchange!(id)

    case App.update_exchange(exchange, exchange_params) do
      {:ok, exchange} ->
        conn
        |> put_flash(:info, "Exchange updated successfully.")
        |> redirect(to: Routes.exchange_path(conn, :show, exchange))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", exchange: exchange, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    exchange = App.get_exchange!(id)
    {:ok, _exchange} = App.delete_exchange(exchange)

    conn
    |> put_flash(:info, "Exchange deleted successfully.")
    |> redirect(to: Routes.exchange_path(conn, :index))
  end
end
