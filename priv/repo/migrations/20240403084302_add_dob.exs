defmodule BettingSystem.Repo.Migrations.AddDob do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :dob, :date
    end
  end
end
