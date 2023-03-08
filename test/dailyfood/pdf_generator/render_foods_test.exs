defmodule Dailyfood.PdfGenerator.RenderFoodsTest do
  alias Dailyfood.PdfGenerator.RenderFoods
  use Dailyfood.DataCase, async: true
  import Dailyfood.Factory

  describe "call/1" do
    test "when given a list of foods, return a html string" do
      food1 = build(:food)
      food2 = build(:food, %{description: "Feijão"})
      foods = [food1, food2]

      response = RenderFoods.call(foods)

      expected_response = [
        "  <div style=\"padding: 5px 20px; border-style: solid; border-width: 0px 0px 1px 0px; border-color: gray;\">\n    <label>\n      Arroz - 100g\n    </label>\n  </div>\n",
        "  <div style=\"padding: 5px 20px; border-style: solid; border-width: 0px 0px 1px 0px; border-color: gray;\">\n    <label>\n      Feijao - 100g\n    </label>\n  </div>\n"
      ]

      assert expected_response == response
    end
  end
end
