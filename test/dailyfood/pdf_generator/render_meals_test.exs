defmodule Dailyfood.PdfGenerator.RenderMealsTest do
  alias Dailyfood.PdfGenerator.RenderMeals
  use Dailyfood.DataCase, async: true
  import Dailyfood.Factory

  describe "call/1" do
    test "when given a list of meal, return a html string" do
      food1 = build(:food)
      food2 = build(:food, %{description: "Feijão"})
      foods = [food1, food2]

      meal = build(:meal, %{foods: foods})

      response = RenderMeals.call([meal])

      expected_response = [
        "  <div style=\"padding-top: 10px;\">\n    <div style=\"padding: 5px 10px; display: flex; flex-direction: column; border-style: solid; border-width: 2px;\">\n      <label style=\"padding: 0px 0px 10px 0px\">\n        28/02/2023 - 23:00\n      </label>\n      <label style=\"padding: 0px 0px 10px 0px\">\n        Almoco\n      </label>\n      <label style=\"padding: 0px 0px 10px 0px\">\n        total: 200g\n      </label>\n    </div>\n    <div style=\"border-style: solid; border-width: 0px 1px 1px 1px;\">\n      <div style=\"padding: 5px 20px; border-style: solid; border-width: 0px 0px 1px 0px; border-color: gray;\">\n    <label>\n      Arroz - 100g\n    </label>\n  </div>\n  <div style=\"padding: 5px 20px; border-style: solid; border-width: 0px 0px 1px 0px; border-color: gray;\">\n    <label>\n      Feijao - 100g\n    </label>\n  </div>\n\n    </div>\n  </div>\n"
      ]

      assert expected_response == response
    end
  end
end
