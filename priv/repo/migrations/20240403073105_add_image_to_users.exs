defmodule BettingSystem.Repo.Migrations.AddImageToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :image, :string, default: "/images/default.jpeg"
    end
  end
end
