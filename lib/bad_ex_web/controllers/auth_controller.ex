defmodule BadExWeb.AuthController do
  use BadExWeb, :controller
  plug Ueberauth

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case BadEx.App.User.from_auth(auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated as #{user.email}")
        |> put_session(:current_user, user)
        |> configure_session(renew: true)
        |> redirect(to: "/")

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end

  def logout(conn, _params) do
    conn
    |> delete_session(:current_user)
    |> redirect(to: "/")
  end
end
