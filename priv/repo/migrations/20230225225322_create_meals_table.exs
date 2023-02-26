defmodule Dailyfood.Repo.Migrations.CreateMealsTable do
  use Ecto.Migration

  def change do
    create table(:meals) do
      add :description, :string
      add :measurement_date, :"time without time zone"
      add :user_id, references(:users)

      timestamps()
    end
  end
end
