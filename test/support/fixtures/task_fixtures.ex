defmodule CarPooling.TaskFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CarPooling.Task` context.
  """

  @doc """
  Generate a car.
  """
  def car_fixture(attrs \\ %{}) do
    {:ok, car} =
      attrs
      |> Enum.into(%{
        seats: 42
      })
      |> CarPooling.Task.create_car()

    car
  end

  @doc """
  Generate a journey.
  """
  def journey_fixture(attrs \\ %{}) do
    {:ok, journey} =
      attrs
      |> Enum.into(%{
        car_id: 42,
        people: 42
      })
      |> CarPooling.Task.create_journey()

    journey
  end
end
