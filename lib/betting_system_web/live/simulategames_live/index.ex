defmodule BettingSystemWeb.SimulategamesLive.Index do
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

  def mount(_params, session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"]) |> Repo.preload(:betslips)

    games = Games.list_games()

    {:ok,
     socket
     |> assign(:user, user)
     |> assign(:games, games)
     |> assign(:pending_error, "")}
  end

  def handle_event("simulate", _params, socket) do
    pending_games = Games.list_pending_games()
    pending_error = ""
    IO.inspect(pending_games)

    pending_error =
      if pending_games == [] do
        "no games are pending"
      else
        ""
      end

    ## simulate games
    Enum.each(pending_games, fn game ->
      random_result = Enum.random(["team1 win", "game_draw", "team2 win"])

      random_updates = %{"status" => "completed", "result" => random_result}
      Games.update_games_check(game, random_updates)
    end)

    users_with_pending_bets_ids = Bet.get_users_with_pending_bets()
    users_with_pending_games = Accounts.get_users_with_ids(users_with_pending_bets_ids)

    Enum.map(users_with_pending_games, fn user ->
      user_betslips = Betslips.get_unchecked_betslips_for_user(user.id)

      Enum.each(user_betslips, fn betslip ->
        game_id = betslip.game_id
        game = Games.get_game!(game_id)

        ## updating users betslips
        case game.status do
          "completed" ->
            if game.result == betslip.result_type do
              Betslips.update_betslip(betslip, %{"end_result" => "won"})
            else
              Betslips.update_betslip(betslip, %{"end_result" => "lost"})
            end

          "pending" ->
            _pending = "pending"
        end
      end)

      ## get bets for user
      user_bets = Bet.get_all_bets(user.id)
      IO.write("I got here at user bets")

      Enum.each(user_bets, fn bet ->
        ## get updated betslips for in bet
        bet_slips_ids = Map.values(bet.bet_items)
        ## check each betslip in bet
        bet_status =
          Enum.reduce(bet_slips_ids, :win, fn x, acc ->
            IO.write("Checking betslip for game ID #{x}")
            betslip = Betslips.get_betslip_by_id(x)
            IO.inspect(betslip)
            IO.write("above inspected betslip")

            case betslip.end_result do
              "won" -> acc
              "lost" -> :lost
              _ -> false
            end
          end)

        IO.inspect(bet_status)
        IO.write("inspecting bet_status above")

        case bet_status do
          :win ->
            Bet.update_bets(bet, %{"end_result" => "win", "status" => "closed"})
            UserNotifier.bet_win_results_email(bet, user)
            IO.write("i got here at win")

          :lost ->
            Bet.update_bets(bet, %{"end_result" => "lost", "status" => "closed"})
            UserNotifier.bet_loss_results_email(bet, user)
            IO.write("i got here at lost")

          false ->
            _false = "false"
        end
      end)
    end)

    IO.write("THE END")

    games = Games.list_games()

    {:noreply,
     socket
     |> assign(:games, games)
     |> assign(:pending_error, pending_error)}
  end
end
