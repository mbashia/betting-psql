defmodule BettingSystem.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset
  alias BettingSystem.Accounts.User
  alias BettingSystem.Sports.Sport
  alias BettingSystem.Betslips.Betslip

  schema "games" do
    field :date, :date
    field :draw, :float
    field :location, :string
    field :lose, :float
    field :result, :string, default: "pending"
    field :status, :string, default: "pending"
    field :team1, :string
    field :team2, :string
    # field :type, :string
    field :win, :float
    belongs_to :user, User, foreign_key: :user_id
    belongs_to :sport, Sport, foreign_key: :sport_id
    has_many :betslips, Betslip
    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [
      :date,
      :status,
      :result,
      :location,
      :win,
      :draw,
      :lose,
      :user_id,
      :sport_id,
      :team1,
      :team2
    ])
    |> validate_required([
      :date,
      :status,
      :result,
      :location,
      :win,
      :draw,
      :lose,
      :user_id,
      :sport_id,
      :team1,
      :team2
    ])
  end
end
