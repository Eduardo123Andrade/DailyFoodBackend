defmodule Dailyfood.PdfGenerator.HtmlGenerator do
  alias Dailyfood.PdfGenerator.RenderMeals
  alias Dailyfood.Meals.Meal

  alias Dailyfood.Foods.Food

  @food1 %Food{
    id: "",
    description: "Arroz",
    weight: 100
  }

  @food2 %Food{
    id: "",
    description: "Feijão",
    weight: 150
  }

  @food3 %Food{
    id: "",
    description: "Soja",
    weight: 100
  }

  @food4 %Food{
    id: "",
    description: "Cuscuz",
    weight: 150
  }

  @meal1 %Meal{
    id: "",
    description: "Almoço",
    user_id: "",
    foods: [@food1, @food2, @food3],
    measurement_date: ~N[2023-03-07 12:28:00]
  }

  @meal2 %Meal{
    id: "",
    description: "Jantar",
    user_id: "",
    foods: [@food4, @food3],
    measurement_date: ~N[2023-03-07 18:28:00]
  }

  def call do
    meals = [@meal1, @meal2]

    """
    <body>
      <div style="height: 65px; display: flex; flex-direction: row;">
        <div style="background-color: brown;height: 100%;width: 5%;">
        </div>
        <div style="width: 100%;">
          <div style="padding: 5px 10px; border-style: solid; border-width: 1px; margin-bottom: 1px;">
            <label>
              Eduardo Andrade
            </label>
          </div>
          <div style="padding: 5px 10px; border-style: solid; border-width: 1px; margin-bottom: 1px;">
            <label>
              28/02/2023 - 31/03/2023
            </label>
          </div>
        </div>
      </div>
      <div style="margin-top: 10px;">
          #{RenderMeals.call(meals)}
      </div>
    </body>
    """
  end

  # defp normalize(value), do: value |> String.normalize(:nfd) |> String.replace(~r/[^A-z\s]/u, "")

  # defp zero_to_left(num), do: String.pad_leading(to_string(num), 2, "0")

  # defp render_meals(meals), do: Enum.map(meals, &render_meal/1)

  # defp render_meal(%Meal{} = meal) do
  #   %Meal{
  #     description: description,
  #     measurement_date: measurement_date,
  #     foods: foods
  #   } = meal

  #   total_weight = sum_foods_weight(foods)

  #   """
  #     <div style="padding-top: 10px;">
  #       <div style="padding: 5px 10px; display: flex; flex-direction: column; border-style: solid; border-width: 2px;">
  #         <label style="padding: 0px 0px 10px 0px">
  #           #{format_date(measurement_date)}
  #         </label>
  #         <label style="padding: 0px 0px 10px 0px">
  #           #{normalize(description)}
  #         </label>
  #         <label style="padding: 0px 0px 10px 0px">
  #           total: #{total_weight}g
  #         </label>
  #       </div>
  #       <div style="border-style: solid; border-width: 0px 1px 1px 1px;">
  #       #{render_foods(foods)}
  #       </div>
  #     </div>
  #   """
  # end

  # defp format_date(%NaiveDateTime{} = date) do
  #   %{
  #     year: year,
  #     month: month,
  #     day: day,
  #     hour: hour,
  #     minute: minute
  #   } = date

  #   "#{zero_to_left(day)}/#{zero_to_left(month)}/#{zero_to_left(year)} - #{zero_to_left(hour)}:#{zero_to_left(minute)}"
  # end

  # defp sum_foods_weight(foods) do
  #   total =
  #     foods
  #     |> Enum.map(&get_weight/1)
  #     |> Enum.sum()

  #   total
  # end

  # defp get_weight(%{weight: weight}), do: weight

  # defp render_foods(foods), do: Enum.map(foods, &render_food/1)

  # defp render_food(%Food{} = food) do
  #   """
  #     <div style="padding: 5px 20px; border-style: solid; border-width: 0px 0px 1px 0px; border-color: gray;">
  #       <label>
  #         #{normalize(food.description)} - #{food.weight}g
  #       </label>
  #     </div>
  #   """
  # end
end
