defmodule Dailyfood.PdfGenerator.RenderMeals do
  alias Dailyfood.Meals.Meal
  alias Dailyfood.PdfGenerator.{NormalizeString, RenderFoods, ZeroToLeft}

  def call(meals), do: Enum.map(meals, &render_meal/1)

  defp get_weight(%{weight: weight}), do: weight

  defp sum_foods_weight(foods), do: foods |> Enum.map(&get_weight/1) |> Enum.sum()

  defp format_date(%NaiveDateTime{} = date) do
    date_str =
      "#{ZeroToLeft.call(date.day)}/#{ZeroToLeft.call(date.month)}/#{ZeroToLeft.call(date.year)}"

    time_str = "#{ZeroToLeft.call(date.hour)}:#{ZeroToLeft.call(date.minute)}"

    "#{date_str} - #{time_str}"
  end

  defp render_meal(%Meal{} = meal) do
    %Meal{
      description: description,
      measurement_date: measurement_date,
      foods: foods
    } = meal

    total_weight = sum_foods_weight(foods)

    """
      <div style="padding-top: 10px;">
        <div style="padding: 5px 10px; display: flex; flex-direction: column; border-style: solid; border-width: 2px;">
          <label style="padding: 0px 0px 10px 0px">
            #{format_date(measurement_date)}
          </label>
          <label style="padding: 0px 0px 10px 0px">
            #{NormalizeString.call(description)}
          </label>
          <label style="padding: 0px 0px 10px 0px">
            total: #{total_weight}g
          </label>
        </div>
        <div style="border-style: solid; border-width: 0px 1px 1px 1px;">
        #{RenderFoods.call(foods)}
        </div>
      </div>
    """
  end
end
