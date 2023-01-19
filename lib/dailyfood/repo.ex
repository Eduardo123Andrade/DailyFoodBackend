defmodule Dailyfood.Repo do
  use Ecto.Repo,
    otp_app: :dailyfood,
    adapter: Ecto.Adapters.Postgres
end
