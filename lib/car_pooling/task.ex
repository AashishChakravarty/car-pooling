defmodule CarPooling.Task do
  @moduledoc """
  The Task context.
  """

  import Ecto.Query, warn: false
  alias CarPooling.Repo

  alias CarPooling.Task.Car

  @doc """
  Returns the list of cars.

  ## Examples

      iex> list_cars()
      [%Car{}, ...]

  """
  def list_cars do
    Repo.all(Car)
  end

  @doc """
  Gets a single car.

  Raises `Ecto.NoResultsError` if the Car does not exist.

  ## Examples

      iex> get_car!(123)
      %Car{}

      iex> get_car!(456)
      ** (Ecto.NoResultsError)

  """
  def get_car!(id), do: Repo.get!(Car, id)

  @doc """
  Creates a car.

  ## Examples

      iex> create_car(%{field: value})
      {:ok, %Car{}}

      iex> create_car(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_car(attrs \\ %{}) do
    %Car{}
    |> Car.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a car.

  ## Examples

      iex> update_car(car, %{field: new_value})
      {:ok, %Car{}}

      iex> update_car(car, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_car(%Car{} = car, attrs) do
    car
    |> Car.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a car.

  ## Examples

      iex> delete_car(car)
      {:ok, %Car{}}

      iex> delete_car(car)
      {:error, %Ecto.Changeset{}}

  """
  def delete_car(%Car{} = car) do
    Repo.delete(car)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking car changes.

  ## Examples

      iex> change_car(car)
      %Ecto.Changeset{data: %Car{}}

  """
  def change_car(%Car{} = car, attrs \\ %{}) do
    Car.changeset(car, attrs)
  end

  alias CarPooling.Task.Journey

  @doc """
  Returns the list of journeys.

  ## Examples

      iex> list_journeys()
      [%Journey{}, ...]

  """
  def list_journeys do
    Repo.all(Journey)
  end

  @doc """
  Gets a single journey.

  Raises `Ecto.NoResultsError` if the Journey does not exist.

  ## Examples

      iex> get_journey!(123)
      %Journey{}

      iex> get_journey!(456)
      ** (Ecto.NoResultsError)

  """
  def get_journey!(id), do: Repo.get!(Journey, id)
  def get_journey(id), do: Repo.get(Journey, id)

  @doc """
  Creates a journey.

  ## Examples

      iex> create_journey(%{field: value})
      {:ok, %Journey{}}

      iex> create_journey(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_journey(attrs \\ %{}) do
    %Journey{}
    |> Journey.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a journey.

  ## Examples

      iex> update_journey(journey, %{field: new_value})
      {:ok, %Journey{}}

      iex> update_journey(journey, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_journey(%Journey{} = journey, attrs) do
    journey
    |> Journey.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a journey.

  ## Examples

      iex> delete_journey(journey)
      {:ok, %Journey{}}

      iex> delete_journey(journey)
      {:error, %Ecto.Changeset{}}

  """
  def delete_journey(%Journey{} = journey) do
    Repo.delete(journey)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking journey changes.

  ## Examples

      iex> change_journey(journey)
      %Ecto.Changeset{data: %Journey{}}

  """
  def change_journey(%Journey{} = journey, attrs \\ %{}) do
    Journey.changeset(journey, attrs)
  end

  def get_journeys_by_car_id(car_id) do
    from(journey in Journey,
      where: journey.car_id == ^car_id
    )
    |> Repo.all()
  end

  def get_journey_by_id(journey_id) do
    get_journey(journey_id) |> Repo.preload(:car)
  end

  def get_car_by_minimum_seats(seats) do
    from(car in Car,
      left_join: journey in assoc(car, :journey),
      where: car.seats >= ^seats and is_nil(journey.car_id),
      order_by: car.seats,
      limit: 1
    )
    |> Repo.one()
  end

  def get_not_assigned_journey_by_maximum_people(people) do
    from(journey in Journey,
      where: journey.people <= ^people and is_nil(journey.car_id),
      order_by: journey.id,
      limit: 1
    )
    |> Repo.one()
  end

  def put_cars(cars) do
    Ecto.Multi.new()
    |> Ecto.Multi.delete_all(:delete_cars, Car)
    |> Ecto.Multi.run(:create_cars, fn _repo, _ ->
      Enum.reduce_while(cars, {:ok, []}, fn car, {_, acc} ->
        case create_car(car) do
          {:ok, car_result} ->
            {:cont, {:ok, acc ++ [car_result]}}

          {:error, error} ->
            {:halt, {:error, error}}
        end
      end)
    end)
    |> Repo.transaction()
  end

  def add_journey(params) do
    Ecto.Multi.new()
    |> Ecto.Multi.run(:journey, fn _, _ ->
      create_journey(params)
    end)
    |> multi_get_car("add_journey", params["people"])
    |> multi_assigned_journey()
    |> Repo.transaction()
  end

  def dropoff(id) do
    Ecto.Multi.new()
    |> Ecto.Multi.run(:journey, fn _, _ ->
      case get_journey(id) |> Repo.preload(:car) do
        nil ->
          {:error, :not_found}

        %{car: nil} ->
          {:error, :not_found}

        %Journey{} = journey ->
          {:ok, journey}
      end
    end)
    |> Ecto.Multi.delete(:delete_journey, fn %{journey: journey} ->
      journey
    end)
    |> multi_get_car("dropoff")
    |> multi_assigned_journey()
    |> Repo.transaction()
  end

  def multi_get_car(multi, type, people \\ 0)

  def multi_get_car(multi, "add_journey", people) do
    multi
    |> Ecto.Multi.run(:car, fn _, _ ->
      {:ok, get_car_by_minimum_seats(people)}
    end)
  end

  def multi_get_car(multi, "dropoff", _people) do
    multi
    |> Ecto.Multi.run(:car, fn _, %{journey: journey} ->
      {:ok, journey.car}
    end)
  end

  def multi_assigned_journey(multi) do
    multi
    |> Ecto.Multi.run(:assign_journey, fn _, %{car: car} ->
      maximum_people = get_maximum_people(car)

      {:ok, get_not_assigned_journey_by_maximum_people(maximum_people)}
    end)
    |> Ecto.Multi.run(:update_journey, fn _, %{car: car, assign_journey: assign_journey} ->
      case assign_journey do
        nil ->
          {:ok, nil}

        assign_journey ->
          update_journey(assign_journey, %{car_id: car.id})
      end
    end)
  end

  def get_maximum_people(nil), do: 0
  def get_maximum_people(car), do: car.seats
end
