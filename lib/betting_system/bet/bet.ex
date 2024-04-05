defmodule BettingSystem.Bet do
  import Ecto.Query, warn: false
  alias BettingSystem.Repo

  alias BettingSystem.Bet.Bets
  alias BettingSystem.Betslips.Betslip

  def get_all_bets(id) do
    Repo.all(from b in Bets, where: b.user_id == ^id)
  end

  def get_users_with_pending_bets() do
    Repo.all(from b in Bets, where: b.status == "open", distinct: true, select: b.user_id)
  end

  def get_all_bets_by_filter(id, filter) do
    Repo.all(from b in Bets, where: b.user_id == ^id and b.end_result == ^filter)
  end

  def get_bet_by_betid(betid) do
    Repo.one(from b in Bets, where: b.bet_id == ^betid)
  end

  def get_all_betslips_in_bet(betid) do
    bet = get_bet_by_betid(betid)
    ids = bet.bet_items |> Enum.map(fn {_k, v} -> v end)
    betslips = get_bet_items_from_bet(ids)
    betslips
  end

  def get_bet_items_from_bet(bet_item_ids) do
    IO.inspect(
      from(o in Betslip, where: o.id in ^bet_item_ids)
      |> Repo.all()
      |> Repo.preload(:game)
    )
  end

  def list_bets do
    Repo.all(Bets)
  end

  def get_bets!(id), do: Repo.get!(Bets, id)

  def create_bets(attrs \\ %{}) do
    %Bets{}
    |> Bets.changeset(attrs)
    |> Repo.insert()
  end

  def update_bets(%Bets{} = bets, attrs) do
    bets
    |> Bets.changeset(attrs)
    |> Repo.update()
  end

  def delete_bets(%Bets{} = bets) do
    Repo.delete(bets)
  end

  def change_bets(%Bets{} = bets, attrs \\ %{}) do
    Bets.changeset(bets, attrs)
  end
end
