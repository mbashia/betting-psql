defmodule BettingSystemWeb.BetsLive.Index do
  use BettingSystemWeb, :live_view
  alias BettingSystem.Users
  alias BettingSystem.Games
  alias BettingSystem.Bet
  alias BettingSystem.Accounts.User
  alias BettingSystem.Accounts
  alias BettingSystem.Repo
  alias BettingSystem.Games
  alias BettingSystem.Betslips
  alias BettingSystem.Accounts.UserNotifier
  alias Phoenix.LiveView.JS

  @impl true
  def mount(%{"id" => id}, session, socket) do
    user_to_view = Accounts.get_user!(id)
    current_user = Accounts.get_user_by_session_token(session["user_token"])
    user_bets = Bet.get_all_bets(user_to_view.id) |> Enum.reverse()

    {:ok,
     socket
     |> assign(:user_to_view, user_to_view)
     |> assign(:user, current_user)
     |> assign(:bets, user_bets)}
  end

  def get_games(betid) do
    Bet.get_all_betslips_in_bet(betid)
  end

  def get_profit(betid) do
    bet = Bet.get_bet_by_betid(betid)

    case bet.end_result do
      "win" -> "loss" <> "#{bet.payout}"
      "lost" -> "profit" <> "#{bet.payout}"
      "nothing" -> "Not Over Yet"
    end
  end

  def get_game(game_id) do
    game = Games.get_game!(game_id)
    game.team1 <> " Vs " <> game.team2
  end
end
