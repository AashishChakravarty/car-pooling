defmodule CarPoolingWeb.StatusController do
  use CarPoolingWeb, :controller

  action_fallback CarPoolingWeb.FallbackController

  def index(conn, _params) do
    send_resp(conn, :ok, "")
  end
end
