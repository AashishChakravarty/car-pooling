defmodule CarPooling.Repo.Migrations.CreateJourneys do
  use Ecto.Migration

  def change do
    create table(:journeys) do
      add :car_id, references(:cars, on_delete: :delete_all), null: true
      add :people, :integer, null: false

      timestamps()
    end

    create index(:journeys, :people)
  end
end
