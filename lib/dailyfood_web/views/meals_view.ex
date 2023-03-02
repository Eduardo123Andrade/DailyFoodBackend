defmodule DailyfoodWeb.MealsView do
  use DailyfoodWeb, :view

  alias Dailyfood.Meals.Meal

  def render("create.json", %{meal: %Meal{} = meal}) do
    %{
      message: "Meal created",
      meal: meal
    }
  end

  def render("meal.json", %{meal: %Meal{} = meal}), do: %{meal: meal}

  def render("meals.json", %{meals: meals}), do: Enum.map(meals, &render_meal_from_list/1)

  defp render_meal_from_list(%Meal{} = meal), do: render("meal.json", %{meal: meal})
end
