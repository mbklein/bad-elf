defmodule BadExWeb.Context do
  @behaviour Plug

  import Plug.Conn
  def init(opts), do: opts

  def call(conn, _) do
    user = conn |> fetch_session |> get_session(:current_user)
    Absinthe.Plug.put_options(conn, context: %{user: user})
  end
end
