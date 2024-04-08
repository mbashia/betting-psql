defmodule BettingSystemWeb.GameLiveTest do
  @moduledoc false
  use BettingSystemWeb.ConnCase

  import Phoenix.LiveViewTest

  describe("Testing the Highlights on game live ") do
    test "We see the highlights", %{conn: conn} do
      conn = assign(conn, :current_user, %{id: 1, name: "Test User"})

      {:ok, index_live, html} =
        live(
          conn,
          Routes.game_index_path(conn, :index)
        )

      assert html =~ "Highlights"
    end
  end
end
