defmodule Dailyfood.Meals.Create do
  alias Dailyfood.Error
  alias Dailyfood.Meals.Meal
  alias Dailyfood.Repo

  def call(%{"foods" => foods_params, "user_id" => user_id} = params) do
    meal_changeset = Meal.changeset(params, foods_params)

    with {:ok, %Meal{}} <- Meal.build(meal_changeset),
         {:ok, _user} <- Dailyfood.get_user_by_id(user_id),
         {:ok, %Meal{}} = meal <- Repo.insert(meal_changeset) do
      meal
    else
      {:error, %Error{}} = error -> error
      {:error, result} -> {:error, Error.build(:bad_request, result)}
    end
  end
end
