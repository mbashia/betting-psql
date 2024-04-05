defmodule BettingSystemWeb.GameLive.Completed do
  use BettingSystemWeb, :live_view
  # alias  BettingSystem.Accounts.User
  alias BettingSystem.Users
  alias Phoenix.LiveView.JS
  alias BettingSystem.Bet
  alias BettingSystem.Accounts
  alias BettingSystem.Games
  alias BettingSystem.Betslips

  def mount(_params, session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])

    {:ok,
     socket
     |> assign(:user, user)
     |> assign(:games, Games.list_completed_games())}
  end

  def render(assigns) do
    ~H"""
    <div id="myModal" class="modal">
      <div class="modal-content pt-12 ">
        <div class="w-[100%] flex flex-col  text-white poppins-regular text-lg">
          <div class="flex justify-evenly">
            <span class="p-2 font-semibold ">Sport</span>
            <span class="p-2 font-semibold ">Teams</span>

            <span class="p-2 font-semibold ">Status</span>
            <span class="p-2 font-semibold ">Date</span>

            <span class="p-2 font-semibold ">Location</span>
            <span class="p-2 font-semibold ">Win</span>

            <span class="p-2 font-semibold ">Lose</span>

            <span class="p-2 font-semibold ">Draw</span>
            <span class="p-2 font-semibold ">Result</span>
          </div>
          <div class="flex flex-col justify-evenly">
            <%= for game <- @games do %>
              <div class="flex justify-evenly border-b-[1px] border-gray-700 hover:bg-blue-100/50 transition-all ease-in-out duration-500  ">
                <div class="text-sm md:text-base  mb-4 "><%= game.sport.name %></div>

                <div class="text-sm md:text-base  mb-4 "><%= game.team1 %> Vs <%= game.team2 %></div>

                <div class="text-sm md:text-base  mb-4"><%= game.status %></div>
                <div class="text-sm md:text-base  mb-4"><%= game.date %></div>
                <div class="text-sm md:text-base  mb-4"><%= game.location %></div>

                <div class="text-sm md:text-base  mb-4"><%= game.win %></div>

                <div class="text-sm md:text-base  mb-4"><%= game.draw %></div>

                <div class="text-sm md:text-base  mb-4"><%= game.lose %></div>
                <div class="text-sm md:text-base  mb-4"><%= game.result %></div>
                <div>
                  <button
                    class="w-[50px] h-[50px] object-cover "
                    phx-click={
                      JS.toggle(to: "#item#{game.id}", in: "fade-in-scale", out: "fade-out-scale")
                    }
                  >
                    <%= Heroicons.icon("plus",
                      type: "solid",
                      class: "h-8   font-bold w-8"
                    ) %>
                  </button>
                </div>
              </div>
              <div id={"item#{game.id}"} class="hidden p-2 w-[100%] flex justify-center items-center">
                <div class="border flex justify-between b px-6">
                  <div class="flex flex-col gap-4">
                    <span>Total Bets placed</span>
                    <span>Total Bets Won</span>
                    <span>Total Bets Lost</span>
                    <span>Total Bet Profit</span>
                  </div>

                  <div class="flex flex-col gap-4">
                    <span><%= bets_placed(game.id) %></span>
                    <span><%= bets_won(game.id) %></span>
                    <span><%= bets_lost(game.id) %></span>
                    <span><%= get_profit(game.id) %></span>
                  </div>
                </div>
              </div>
            <% end %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def bets_placed(game_id) do
    Betslips.get_games_in_bet(game_id)
  end

  def get_profit(game_id) do
    betslips = Betslips.preloaded_betslips(game_id)

    amount =
      Enum.map(betslips, fn slip ->
        profit =
          case slip.bet.end_result do
            "won" -> slip.bet.payout
            "lost" -> slip.bet.amount
            "nothing"->0.0
          end
      end)
      |> Enum.sum()
  end

  def bets_won(game_id) do
    Betslips.get_games_in_bet_won(game_id)
  end

  def bets_lost(game_id) do
    Betslips.get_games_in_bet_lost(game_id)
  end
end
