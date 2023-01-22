defmodule CarPooling.Task.Car do
  use Ecto.Schema
  import Ecto.Changeset

  @required ~W(seats)a
  @optional ~W(id)a
  @only @required ++ @optional

  @derive {Jason.Encoder, only: @only}
  schema "cars" do
    field :seats, :integer

    has_many(:journeys, CarPooling.Task.Journey)
    timestamps()
  end

  @doc false
  def changeset(car, attrs) do
    car
    |> cast(attrs, @only)
    |> validate_required(@required)
  end
end
