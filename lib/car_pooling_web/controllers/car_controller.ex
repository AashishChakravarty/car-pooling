defmodule CarPoolingWeb.CarController do
  use CarPoolingWeb, :controller

  alias CarPooling.Task

  action_fallback CarPoolingWeb.FallbackController

  def add_cars(conn, %{"_json" => cars}) when is_list(cars) do
    with {:ok, _} <- Task.put_cars(cars) do
      conn
      |> send_resp(200, "OK")
    else
      _ ->
        {:error, :bad_request}
    end
  end

  def add_cars(_conn, _params) do
    {:error, :bad_request}
  end
end
