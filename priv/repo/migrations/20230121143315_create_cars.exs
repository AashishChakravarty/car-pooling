defmodule CarPooling.Repo.Migrations.CreateCars do
  use Ecto.Migration

  def change do
    create table(:cars) do
      add :seats, :integer, null: false

      timestamps()
    end

    create index(:cars, :seats)
  end
end
