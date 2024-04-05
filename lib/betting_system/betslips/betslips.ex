defmodule BettingSystem.Betslips do
 

  import Ecto.Query, warn: false
  alias BettingSystem.Repo

  alias BettingSystem.Betslips.Betslip


  def update_all(ids, bet_id) do
    from(m in Betslip,
      where: m.id in ^ids
    )
    |> Repo.update_all(set: [status: "out_of_slip", bet_id: bet_id])
  end

  def list_betslips do
    Repo.all(Betslip)
  end

  def get_games_in_bet(game_id) do
    Repo.one(
      from b in Betslip,
        where: b.game_id == ^game_id and b.status == "out_of_slip",
        select: count(b.id)
    )
  end

  def preloaded_betslips(game_id) do
    Repo.all(
      from b in Betslip,
        where: b.game_id == ^game_id and b.status == "out_of_slip"
    )
    |> Repo.preload(:bet)
  end

  def get_games_in_bet_won(game_id) do
    Repo.one(
      from b in Betslip,
        where: b.game_id == ^game_id and b.status == "out_of_slip" and b.end_result == "won",
        select: count(b.id)
    )
  end

  def get_games_in_bet_lost(game_id) do
    Repo.one(
      from b in Betslip,
        where: b.game_id == ^game_id and b.status == "out_of_slip" and b.end_result == "lost",
        select: count(b.id)
    )
  end

  def get_betslips(id) do
    Repo.all(from b in Betslip, where: b.user_id == ^id and b.status == "in_betslip")
    |> Repo.preload(:game)
  end

  def check_betslip!(id, game_id) do
    Repo.one(
      from b in Betslip,
        where: b.user_id == ^id and b.game_id == ^game_id and b.status == "in_betslip"
    )
  end

  def get_betslip_by_id(id) do
    Repo.one(from b in Betslip, where: b.id == ^id)
  end

  def getting_betslip(id, game_id) do
    Repo.one(from b in Betslip, where: b.user_id == ^id and b.game_id == ^game_id)
  end

  def get_betslip_user_id(id) do
    Repo.all(from b in Betslip, where: b.user_id == ^id)
    |> Repo.preload(:game)
  end

  def get_unchecked_betslips_for_user(id) do
    Repo.all(from b in Betslip, where: b.user_id == ^id and b.end_result == "nothing")
    |> Repo.preload(:game)
  end

 
  def get_betslip!(id), do: Repo.get!(Betslip, id)

 
  def create_betslip(attrs \\ %{}) do
    %Betslip{}
    |> Betslip.changeset(attrs)
    |> Repo.insert()
  end

  
  def update_betslip(%Betslip{} = betslip, attrs) do
    betslip
    |> Betslip.changeset(attrs)
    |> Repo.update()
  end

 
  def delete_betslip(%Betslip{} = betslip) do
    Repo.delete(betslip)
  end

  def change_betslip(%Betslip{} = betslip, attrs \\ %{}) do
    Betslip.changeset(betslip, attrs)
  end
end
