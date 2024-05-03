defmodule BettingSystemWeb.GameLiveTest do
  @moduledoc false
  #  use BettingSystemWeb.ConnCase

  # import Phoenix.LiveViewTest

  use ExUnit.Case
  alias BettingSystemWeb.GameLive
  import ExUnit.Case

  defp create_socket() do
    %{socket: %Phoenix.LiveView.Socket{}}
  end

  describe "Socket state" do
    setup do
      create_socket()
    end

    test "odds are zero", %{socket: socket} do
      socket =
        socket
        |> SurveyResultsLive.Index.mount()

      assert
      socket.assigns.total_odds == 0.0
    end
  end

  # describe("Testing the Highlights on game live ") do
  #   test "We see the highlights", %{conn: conn} do
  #     conn = assign(conn, :current_user, %{id: 1, name: "Test User" ,role: "SuperAdmin"})

  #     {:ok, index_live, html} =
  #       live(
  #         conn,
  #         Routes.page_path(conn, :index)
  #       )

  #     assert html =~ "Highlights"
  #   end
  # end
end
