defmodule Barkbot.Repo do
  use Ecto.Repo,
    otp_app: :barkbot,
    adapter: Ecto.Adapters.Postgres
end
