defmodule BettingSystemWeb.UserLive.Index do
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
  def mount(_params, session, socket) do
    # :timer.send_interval(20000, self(), :update_games)
    if connected?(socket) do
      Games.subscribe()
    end

    user = Accounts.get_user_by_session_token(session["user_token"]) |> Repo.preload(:betslips)
    users = Users.list_users()
    user_changeset = Accounts.change_user_profile(user)
    IO.inspect(user)
    user_bets = Bet.get_all_bets(user.id) |> Enum.reverse()

    number =
      if length(user_bets) == 1 do
        "bet"
      else
        "bets"
      end

    {:ok,
     socket
     |> assign(:clients, users)
     |> assign(:user, user)
     |> assign(:check_bet_history, 0)
     |> assign(:bets, user_bets)
     |> assign(:number, number)
     |> assign(:user_changeset, user_changeset)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    IO.write("we are here")
    IO.inspect(id)
    id = String.to_integer(id)
    IO.inspect(id)

    socket
    |> assign(:page_title, "Edit user")
    |> assign(:user_edit, Users.get_user!(id))
  end

  defp apply_action(socket, :view_user, %{"id" => id}) do
    IO.write("we are here")
    IO.inspect(id)
    id = String.to_integer(id)
    IO.inspect(id)
    user_bets = Bet.get_all_bets(id) |> Enum.reverse()

    socket
    |> assign(:user_to_view, Users.get_user!(id))
    |> assign(:bets, user_bets)
  end

  # defp apply_action(socket, :new, _params) do
  #   socket
  #   |> assign(:page_title, "New user")
  #   |> assign(:user, %User{})
  # end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing users")
    |> assign(:sport, nil)
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

  @impl true
  def handle_event("filter_games", params, socket) do
    bets = Bet.get_all_bets_by_filter(socket.assigns.user.id, params["filter"])
    {:noreply, socket |> assign(:bets, bets)}
  end

  # {:ok, _} = Users.delete_user(users)

  # {:noreply, assign(socket, :users, Users.list_users())}

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset =
      socket.assigns.user
      |> Users.change_user(user_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event(
        "update_profile",
        %{
          "user" => user_params
        },
        socket
      ) do
    case Users.update_user(socket.assigns.user, user_params) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(:info, "user updated successfully")}

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.write("error")
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def handle_event("bet history", params, socket) do
    {:noreply,
     socket
     |> assign(:check_bet_history, 1)}
  end

  def handle_event("close_pop_up", params, socket) do
    {:noreply,
     socket
     |> assign(:check_bet_history, 0)}
  end

  @impl true
  def handle_info({:game_updated, _message}, socket) do
    user_betslips = Betslips.get_betslip_user_id(socket.assigns.user.id)

    Enum.each(user_betslips, fn betslip ->
      game_id = betslip.game_id
      game = Games.get_game!(game_id)

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

    # this code from here  i cant rembember i was in the zone and it might not be working check later
    user_bets = Bet.get_all_bets(socket.assigns.user.id)

    Enum.each(user_bets, fn bet ->
      game_ids = Map.values(bet.bet_items)

      bet_status =
        Enum.reduce(game_ids, :win, fn x, acc ->
          IO.write("Checking betslip for game ID #{x}")
          betslip = Betslips.getting_betslip(socket.assigns.user.id, x)
          IO.inspect(betslip)
          IO.write("above inspected betslip")

          case betslip.end_result do
            "won" -> acc
            "lost" -> :lost
            _ -> false
          end
        end)

      case bet_status do
        :win ->
          Bet.update_bets(bet, %{"end_result" => "win", "status" => "closed"})
          UserNotifier.bet_win_results_email(bet, socket.assigns.user)

        :lost ->
          Bet.update_bets(bet, %{"end_result" => "lost", "status" => "closed"})
          UserNotifier.bet_loss_results_email(bet, socket.assigns.user)

        false ->
          _false = "false"
      end
    end)

    {:noreply, socket}
  end

  # def handle_info(:update_games, socket) do
  #   user_betslips = Betslips.get_betslip_user_id(socket.assigns.user.id)

  #   Enum.each(user_betslips, fn betslip ->
  #     game_id = betslip.game_id
  #     game = Games.get_game!(game_id)

  #     case game.status do
  #       "completed" ->
  #         if game.result == betslip.result_type do
  #           Betslips.update_betslip(betslip, %{"end_result" => "won"})
  #         else
  #           Betslips.update_betslip(betslip, %{"end_result" => "lost"})
  #         end

  #       "pending" ->
  #         _pending = "pending"
  #     end
  #   end)

  #   # this code from here  i cant rembember i was in the zone and it might not be working check later
  #   user_bets = Bet.get_all_bets(socket.assigns.user.id)

  #   Enum.each(user_bets, fn bet ->
  #     game_ids = Map.values(bet.bet_items)

  #     bet_status =
  #       Enum.reduce(game_ids, :win, fn x, acc ->
  #         IO.write("Checking betslip for game ID #{x}")
  #         betslip = Betslips.getting_betslip(socket.assigns.user.id, x)
  #         IO.inspect(betslip)
  #         IO.write("above inspected betslip")

  #         case betslip.end_result do
  #           "won" -> acc
  #           "lost" -> :lost
  #           _ -> false
  #         end
  #       end)

  #     case bet_status do
  #       :win ->
  #         Bet.update_bets(bet, %{"end_result" => "win", "status" => "closed"})
  #         UserNotifier.bet_win_results_email(bet, socket.assigns.user)

  #       :lost ->
  #         Bet.update_bets(bet, %{"end_result" => "lost", "status" => "closed"})
  #         UserNotifier.bet_loss_results_email(bet, socket.assigns.user)

  #       false ->
  #         _false = "false"
  #     end
  #   end)

  #   {:noreply, socket}
  # end
end
