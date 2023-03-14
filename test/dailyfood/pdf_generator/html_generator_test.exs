defmodule Dailyfood.PdfGenerator.HtmlGeneratorTest do
  alias Dailyfood.PdfGenerator.HtmlGenerator
  use Dailyfood.DataCase, async: true
  import Dailyfood.Factory

  describe "call/1" do
    test "when given a valid params, return a html string" do
      user = build(:user)
      food1 = build(:food)
      food2 = build(:food, %{description: "Feijão"})
      foods = [food1, food2]

      meal = build(:meal, %{foods: foods})

      params = %{meals: [meal], user: user}

      {:ok, html_content} = HtmlGenerator.call(params)

      expected_response =
        "<body>\n  <div style=\"height: 65px; display: flex; flex-direction: row;\">\n    <div style=\"background-color: brown;height: 100%;width: 5%;\">\n    </div>\n    <div style=\"width: 100%;\">\n      <div style=\"padding: 5px 10px; border-style: solid; border-width: 1px; margin-bottom: 1px;\">\n        <label>\n          Stark\n        </label>\n      </div>\n      <div style=\"padding: 5px 10px; border-style: solid; border-width: 1px; margin-bottom: 1px;\">\n        <label>\n          28/02/2023 - 28/02/2023\n        </label>\n      </div>\n    </div>\n  </div>\n  <div style=\"margin-top: 10px;\">\n      <div style=\"padding-top: 10px;\">\n    <div style=\"padding: 5px 10px; display: flex; flex-direction: column; border-style: solid; border-width: 2px;\">\n      <label style=\"padding: 0px 0px 10px 0px\">\n        28/02/2023 - 23:00\n      </label>\n      <label style=\"padding: 0px 0px 10px 0px\">\n        Almoco\n      </label>\n      <label style=\"padding: 0px 0px 10px 0px\">\n        total: 200g\n      </label>\n    </div>\n    <div style=\"border-style: solid; border-width: 0px 1px 1px 1px;\">\n      <div style=\"padding: 5px 20px; border-style: solid; border-width: 0px 0px 1px 0px; border-color: gray;\">\n    <label>\n      Arroz - 100g\n    </label>\n  </div>\n  <div style=\"padding: 5px 20px; border-style: solid; border-width: 0px 0px 1px 0px; border-color: gray;\">\n    <label>\n      Feijao - 100g\n    </label>\n  </div>\n\n    </div>\n  </div>\n\n  </div>\n</body>\n"

      assert expected_response == html_content
    end
  end
end
