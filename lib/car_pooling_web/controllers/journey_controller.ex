defmodule CarPoolingWeb.JourneyController do
  use CarPoolingWeb, :controller

  alias CarPooling.Task

  action_fallback CarPoolingWeb.FallbackController

  def request_journey(conn, %{"people" => _people} = params) do
    with {:ok, _} <- Task.add_journey(params) do
      conn
      |> send_resp(200, "")
    else
      _ ->
        {:error, :bad_request}
    end
  end

  def request_journey(_conn, _params) do
    {:error, :bad_request}
  end

  def dropoff(conn, %{"ID" => id}) do
    with {:ok, _} <- Task.dropoff(id) do
      conn
      |> send_resp(200, "")
    else
      _ ->
        {:error, :not_found}
    end
  end

  def dropoff(_conn, _params) do
    {:error, :bad_request}
  end

  def locate(conn, %{"ID" => id}) do
    case Task.get_journey_by_id(id) do
      %{car: nil} ->
        send_resp(conn, :no_content, "")

      %{car: car} ->
        conn
        |> put_status(200)
        |> json(car)

      nil ->
        {:error, :not_found}

      _ ->
        {:error, :bad_request}
    end
  end

  def locate(_conn, _params) do
    {:error, :bad_request}
  end
end
