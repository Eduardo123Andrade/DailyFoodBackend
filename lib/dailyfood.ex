defmodule Dailyfood do
  alias Dailyfood.Meals.Create, as: MealCreate
  alias Dailyfood.Meals.Get, as: MealGet

  alias Dailyfood.Users.Create, as: UserCreate
  alias Dailyfood.Users.Get, as: UserGet
  alias Dailyfood.Users.Update, as: UserUpdate

  defdelegate user_create(params), to: UserCreate, as: :call
  defdelegate get_user_by_id(id), to: UserGet, as: :by_id
  defdelegate update_user(params), to: UserUpdate, as: :call

  defdelegate meal_create(params), to: MealCreate, as: :call
  defdelegate get_meals(params), to: MealGet, as: :call
end
