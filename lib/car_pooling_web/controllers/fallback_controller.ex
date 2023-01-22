defmodule CarPoolingWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use CarPoolingWeb, :controller

  # This clause is an example of how to handle resources that cannot be found.

  def call(conn, {:error, :bad_request}) do
    conn
    |> put_status(:bad_request)
    |> put_view(CarPoolingWeb.ErrorView)
    |> render(:"400")
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(CarPoolingWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, :no_content}) do
    conn
    |> put_status(:no_content)
    |> put_view(CarPoolingWeb.ErrorView)
    |> render(:"204")
  end
end
