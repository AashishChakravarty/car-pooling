defmodule CarPooling.TaskTest do
  use CarPooling.DataCase

  alias CarPooling.Task

  describe "cars" do
    alias CarPooling.Task.Car

    import CarPooling.TaskFixtures

    @invalid_attrs %{seats: nil}

    test "list_cars/0 returns all cars" do
      car = car_fixture()
      assert Task.list_cars() == [car]
    end

    test "get_car!/1 returns the car with given id" do
      car = car_fixture()
      assert Task.get_car!(car.id) == car
    end

    test "create_car/1 with valid data creates a car" do
      valid_attrs = %{seats: 42}

      assert {:ok, %Car{} = car} = Task.create_car(valid_attrs)
      assert car.seats == 42
    end

    test "create_car/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Task.create_car(@invalid_attrs)
    end

    test "update_car/2 with valid data updates the car" do
      car = car_fixture()
      update_attrs = %{seats: 43}

      assert {:ok, %Car{} = car} = Task.update_car(car, update_attrs)
      assert car.seats == 43
    end

    test "update_car/2 with invalid data returns error changeset" do
      car = car_fixture()
      assert {:error, %Ecto.Changeset{}} = Task.update_car(car, @invalid_attrs)
      assert car == Task.get_car!(car.id)
    end

    test "delete_car/1 deletes the car" do
      car = car_fixture()
      assert {:ok, %Car{}} = Task.delete_car(car)
      assert_raise Ecto.NoResultsError, fn -> Task.get_car!(car.id) end
    end

    test "change_car/1 returns a car changeset" do
      car = car_fixture()
      assert %Ecto.Changeset{} = Task.change_car(car)
    end
  end

  describe "journeys" do
    alias CarPooling.Task.Journey

    import CarPooling.TaskFixtures

    @invalid_attrs %{car_id: nil, people: nil}

    test "list_journeys/0 returns all journeys" do
      journey = journey_fixture()
      assert Task.list_journeys() == [journey]
    end

    test "get_journey!/1 returns the journey with given id" do
      journey = journey_fixture()
      assert Task.get_journey!(journey.id) == journey
    end

    test "create_journey/1 with valid data creates a journey" do
      valid_attrs = %{car_id: 42, people: 42}

      assert {:ok, %Journey{} = journey} = Task.create_journey(valid_attrs)
      assert journey.car_id == 42
      assert journey.people == 42
    end

    test "create_journey/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Task.create_journey(@invalid_attrs)
    end

    test "update_journey/2 with valid data updates the journey" do
      journey = journey_fixture()
      update_attrs = %{car_id: 43, people: 43}

      assert {:ok, %Journey{} = journey} = Task.update_journey(journey, update_attrs)
      assert journey.car_id == 43
      assert journey.people == 43
    end

    test "update_journey/2 with invalid data returns error changeset" do
      journey = journey_fixture()
      assert {:error, %Ecto.Changeset{}} = Task.update_journey(journey, @invalid_attrs)
      assert journey == Task.get_journey!(journey.id)
    end

    test "delete_journey/1 deletes the journey" do
      journey = journey_fixture()
      assert {:ok, %Journey{}} = Task.delete_journey(journey)
      assert_raise Ecto.NoResultsError, fn -> Task.get_journey!(journey.id) end
    end

    test "change_journey/1 returns a journey changeset" do
      journey = journey_fixture()
      assert %Ecto.Changeset{} = Task.change_journey(journey)
    end
  end
end
