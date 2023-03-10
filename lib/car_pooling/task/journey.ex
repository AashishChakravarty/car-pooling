defmodule CarPooling.Task.Journey do
  use Ecto.Schema
  import Ecto.Changeset

  @required ~W(people)a
  @optional ~W(id car_id)a
  @only @required ++ @optional

  @derive {Jason.Encoder, only: @only}
  schema "journeys" do
    field :people, :integer

    belongs_to(:car, CarPooling.Task.Car)

    timestamps()
  end

  @doc false
  def changeset(journey, attrs) do
    journey
    |> cast(attrs, @only)
    |> validate_required(@required)
    |> unique_constraint(:car_id)
  end
end
