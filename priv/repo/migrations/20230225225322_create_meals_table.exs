defmodule Dailyfood.Repo.Migrations.CreateMealsTable do
  use Ecto.Migration

  def change do
    create table(:meals) do
      add :description, :string
      add :measurement_date, :naive_datetime
      add :user_id, references(:users)

      timestamps()
    end
  end
end
