defmodule Dailyfood.PdfGenerator.RenderFoods do
  alias Dailyfood.Foods.Food
  alias Dailyfood.PdfGenerator.NormalizeString

  def call(foods), do: Enum.map(foods, &render_food/1)

  defp render_food(%Food{} = food) do
    """
      <div style="padding: 5px 20px; border-style: solid; border-width: 0px 0px 1px 0px; border-color: gray;">
        <label>
          #{NormalizeString.call(food.description)} - #{food.weight}g
        </label>
      </div>
    """
  end
end
