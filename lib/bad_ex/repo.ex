defmodule BadEx.Repo do
  use Ecto.Repo,
    otp_app: :bad_ex,
    adapter: Ecto.Adapters.Postgres
end
