defmodule CarPoolingWeb.JourneyController do
  use CarPoolingWeb, :controller

  alias CarPooling.Task

  action_fallback CarPoolingWeb.FallbackController

  def request_journey(conn, %{"people" => people}) do
    with {:ok, _} <- Task.add_journey(people) do
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
      |> send_resp(200, "OK")
    else
      _ ->
        {:error, :not_found}
    end
  end

  def dropoff(_conn, params) do
    {:error, :bad_request}
  end

  def locate(conn, %{"ID" => id}) do
    with nil <- Task.get_journey_by_id(id) do
      {:error, :not_found}
    else
      %{car: nil} ->
        send_resp(conn, :no_content, "No Content")

      %{car: car} ->
        conn
        |> put_status(200)
        |> json(car)

      _ ->
        {:error, :bad_request}
    end
  end

  def locate(_conn, _params) do
    {:error, :bad_request}
  end
end
