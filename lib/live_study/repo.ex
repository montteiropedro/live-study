defmodule LiveStudy.Repo do
  use Ecto.Repo,
    otp_app: :live_study,
    adapter: Ecto.Adapters.Postgres
end
