defmodule BettingSystemWeb.GameLiveTest do
  @moduledoc false
  use PtestWeb.ConnCase

  import Phoenix.LiveViewTest

  describe("Testing the counter on home live ") do
    test "We see the Counter and initial 0", %{conn: conn} do
      {:ok, index_live, html} =
        live(
          conn,
          Routes.home_index_path(conn, :index)
        )

      assert html =~ "Counter"
      assert html =~ "0"
    end
  end
end
