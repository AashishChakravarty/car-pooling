defmodule CarPooling.Repo.Migrations.AddJourneyIndex do
  use Ecto.Migration

  def change do
    create unique_index(:journeys, [:car_id])
  end
end
