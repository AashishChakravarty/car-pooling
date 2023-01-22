defmodule CarPoolingWeb.JourneyController do
  use CarPoolingWeb, :controller

  alias CarPooling.Task

  action_fallback CarPoolingWeb.FallbackController

  def request_journey(conn, %{"people" => people}) do
    with {:ok, %{journey: journey}} <- Task.add_journey(people) do
      conn
      |> put_status(:ok)
      |> json(%{status: true, message: "Journey Created Successfully", data: journey})
    else
      _ ->
        {:error, :bad_request}
    end
  end

  def request_journey(_conn, _params) do
    {:error, :bad_request}
  end

  def dropoff(conn, %{"ID" => id}) do
    with {:ok, %{journey: journey}} <- Task.dropoff(id) do
      conn
      |> put_status(:ok)
      |> json(%{status: true, message: "Dropoff Successfully", data: journey})
    else
      {:error, :not_found} ->
        {:error, :not_found}

      _ ->
        {:error, :bad_request}
    end
  end

  def dropoff(_conn, _params) do
    {:error, :bad_request}
  end

  def locate(conn, %{"ID" => id}) do
    with nil <- Task.get_journey(id) do
      {:error, :not_found}
    else
      %{car_id: nil} ->
        send_resp(conn, :no_content, "")

      %{car_id: _car} = journey ->
        conn
        |> put_status(:ok)
        |> json(%{status: true, message: "Locate Successfully", data: journey})

      _ ->
        {:error, :bad_request}
    end
  end

  def locate(_conn, _params) do
    {:error, :bad_request}
  end
end
