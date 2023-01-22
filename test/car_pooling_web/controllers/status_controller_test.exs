defmodule CarPoolingWeb.StatusControllerTest do
  use CarPoolingWeb.ConnCase

  describe "index" do
    test "get status", %{conn: conn} do
      conn = get(conn, Routes.status_path(conn, :index))
      assert response(conn, :ok)
    end
  end
end
