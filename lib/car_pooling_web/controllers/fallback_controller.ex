defmodule CarPoolingWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use CarPoolingWeb, :controller

  # This clause is an example of how to handle resources that cannot be found.

  def call(conn, {:error, :bad_request}) do
    conn
    |> send_resp(400, "")
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> send_resp(404, "")
  end

  def call(conn, _params) do
    conn
    |> send_resp(405, "Method Not Allowed")
  end
end
