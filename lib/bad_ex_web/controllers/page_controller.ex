defmodule BadExWeb.PageController do
  use BadExWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
