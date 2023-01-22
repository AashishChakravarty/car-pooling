defmodule CarPoolingWeb.JourneyControllerTest do
  use CarPoolingWeb.ConnCase

  import CarPooling.TaskFixtures

  alias CarPooling.Task.Journey

  @create_attrs %{
    car_id: 42,
    people: 42
  }
  @update_attrs %{
    car_id: 43,
    people: 43
  }
  @invalid_attrs %{car_id: nil, people: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all journeys", %{conn: conn} do
      conn = get(conn, Routes.journey_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create journey" do
    test "renders journey when data is valid", %{conn: conn} do
      conn = post(conn, Routes.journey_path(conn, :create), journey: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.journey_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "car_id" => 42,
               "people" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.journey_path(conn, :create), journey: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update journey" do
    setup [:create_journey]

    test "renders journey when data is valid", %{conn: conn, journey: %Journey{id: id} = journey} do
      conn = put(conn, Routes.journey_path(conn, :update, journey), journey: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.journey_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "car_id" => 43,
               "people" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, journey: journey} do
      conn = put(conn, Routes.journey_path(conn, :update, journey), journey: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete journey" do
    setup [:create_journey]

    test "deletes chosen journey", %{conn: conn, journey: journey} do
      conn = delete(conn, Routes.journey_path(conn, :delete, journey))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.journey_path(conn, :show, journey))
      end
    end
  end

  defp create_journey(_) do
    journey = journey_fixture()
    %{journey: journey}
  end
end
