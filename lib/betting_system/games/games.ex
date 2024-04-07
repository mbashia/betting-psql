defmodule BettingSystem.Games do
  @moduledoc """
  The Games context.
  """

  import Ecto.Query, warn: false
  alias BettingSystem.Repo

  alias BettingSystem.Games.Game

  @doc """
  Returns the list of games.

  ## Examples

      iex> list_games()
      [%Game{}, ...]

  """

  def subscribe() do
    Phoenix.PubSub.subscribe(BettingSystem.PubSub, "game_updates")
  end

  #  the code below broadcasts a message to the the topic "mytopic"
  def publish({:ok, game}, tag) do
    new_game =
      game
      |> Repo.preload(:user)

    Phoenix.PubSub.broadcast(BettingSystem.PubSub, "game_updates", {tag, new_game})

    {:ok, game}
  end

  def list_games do
    Repo.all(from g in Game, order_by: [desc: g.status, desc: g.id])
    |> Repo.preload(:sport)
  end

  def list_pending_games() do
    Repo.all(from g in Game, where: g.status == "pending")
  end

  def list_completed_games() do
    Repo.all(from g in Game, where: g.status == "completed") |> Repo.preload(:sport)
  end

  @doc """
  Gets a single game.

  Raises `Ecto.NoResultsError` if the Game does not exist.

  ## Examples

      iex> get_game!(123)
      %Game{}

      iex> get_game!(456)
      ** (Ecto.NoResultsError)

  """
  def insert_games(game_params) do
    Repo.transaction(fn ->
      Enum.each(game_params, fn params ->
        %Game{}
        |> Game.changeset(params)
        |> Repo.insert!()
      end)
    end)
  end
  def get_game!(id), do: Repo.get!(Game, id)

  @doc """
  Creates a game.

  ## Examples

      iex> create_game(%{field: value})
      {:ok, %Game{}}

      iex> create_game(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_game(attrs \\ %{}) do
    %Game{}
    |> Game.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a game.

  ## Examples

      iex> update_game(game, %{field: new_value})
      {:ok, %Game{}}

      iex> update_game(game, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_game(%Game{} = game, attrs) do
    game
    |> Game.changeset(attrs)
    |> Repo.update()
  end

  def update_games_check(%Game{} = game, attrs) do
    game
    |> Game.changeset(attrs)
    |> Repo.update()
    |> publish(:game_updated)
  end

  @doc """
  Deletes a game.

  ## Examples

      iex> delete_game(game)
      {:ok, %Game{}}

      iex> delete_game(game)
      {:error, %Ecto.Changeset{}}

  """
  def delete_game(%Game{} = game) do
    Repo.delete(game)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking game changes.

  ## Examples

      iex> change_game(game)
      %Ecto.Changeset{data: %Game{}}

  """
  def change_game(%Game{} = game, attrs \\ %{}) do
    Game.changeset(game, attrs)
  end
end
