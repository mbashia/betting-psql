defmodule BettingSystem.Repo do
  use Ecto.Repo,
    otp_app: :betting_system,
    adapter: Ecto.Adapters.Postgres
end
