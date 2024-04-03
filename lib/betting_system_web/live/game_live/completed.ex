defmodule BettingSystemWeb.GameLive.Completed do
  use BettingSystemWeb, :live_view
  # alias  BettingSystem.Accounts.User
  alias BettingSystem.Users
  alias Phoenix.LiveView.JS
  alias BettingSystem.Bet
  alias BettingSystem.Accounts

  def mount(_params, session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])

    {:ok,
     socket
     |> assign(:user, user)}
  end

  def render(assigns) do
    ~H"""
    <div id="myModal" class="modal">
      <div class="modal-content pt-12 ">
        This is for complted games
      </div>
    </div>
    """
  end

  def get_games(betid) do
    Bet.get_all_betslips_in_bet(betid)
  end

  def get_profit(betid) do
    bet = Bet.get_bet_by_betid(betid)

    case bet.end_result do
      "won" -> "loss" <> bet.payout
      "lost" -> "profit" <> bet.payout
      "nothing" -> "Not Over Yet"
    end
  end
end
