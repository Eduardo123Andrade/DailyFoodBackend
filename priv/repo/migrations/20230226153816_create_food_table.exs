defmodule Dailyfood.Repo.Migrations.CreateFoodTable do
  use Ecto.Migration

  def change do
    create table(:foods) do
      add :description, :string
      add :weight, :int
      add :meal_id, references(:meals)

      timestamps()
    end
  end
end
