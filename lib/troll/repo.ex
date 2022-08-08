defmodule Troll.Repo do
  use Ecto.Repo,
    otp_app: :troll,
    adapter: Ecto.Adapters.Postgres
end
