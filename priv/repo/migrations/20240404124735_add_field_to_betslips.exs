defmodule BettingSystem.Repo.Migrations.AddFieldToBetslips do
  use Ecto.Migration

  def change do
    alter table(:betslips) do
      add :bet_id, :integer
    end
  end
end
