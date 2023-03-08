defmodule Dailyfood.Meals.Get do
  import Ecto.Query

  alias Dailyfood.Meals.Meal
  alias Dailyfood.Repo
  alias Dailyfood.Users.User

  def by_date(%{"initial_date" => initial_date, "final_date" => final_date, "user_id" => user_id}) do
    start_time = format_date(initial_date, "0-0-0")
    end_time = format_date(final_date, "23-59-59")

    query =
      from meal in Meal,
        join: foods in assoc(meal, :foods),
        order_by: meal.measurement_date,
        where:
          meal.measurement_date >= ^start_time and meal.measurement_date <= ^end_time and
            meal.user_id == ^user_id,
        preload: [foods: foods]

    with {:ok, %User{}} <- Dailyfood.get_user_by_id(user_id) do
      meals = Repo.all(query)
      {:ok, meals}
    end
  end

  def by_ids(%{"meal_ids" => meal_ids, "user_id" => user_id}) do
    query =
      from meal in Meal,
        join: foods in assoc(meal, :foods),
        order_by: meal.measurement_date,
        where: meal.id in ^meal_ids and meal.user_id == ^user_id,
        preload: [foods: foods]

    with {:ok, %User{}} <- Dailyfood.get_user_by_id(user_id) do
      meals = Repo.all(query)
      {:ok, meals}
    end
  end

  defp split_date(date) do
    date
    |> String.split("-")
    |> Enum.map(&String.to_integer/1)
  end

  defp format_date(date, time) do
    [year, month, day] = split_date(date)
    [hour, minute, second] = split_date(time)
    {:ok, date} = NaiveDateTime.new(year, month, day, hour, minute, second)
    date
  end
end
