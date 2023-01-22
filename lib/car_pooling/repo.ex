defmodule CarPooling.Repo do
  use Ecto.Repo,
    otp_app: :car_pooling,
    adapter: Ecto.Adapters.Postgres
end
