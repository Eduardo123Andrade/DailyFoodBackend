defmodule Dailyfood.Meal.MealTest do
  use Dailyfood.DataCase, async: true

  import Dailyfood.Factory

  alias Dailyfood.Foods.Food
  alias Dailyfood.Meals.Meal
  alias Ecto.Changeset

  describe "changeset/2" do
    test "when all params are valid, return a valid changeset" do
      params = build(:meal_params)

      foods = [
        build(:food_params),
        build(:food_params, %{"description" => "Feijao"})
      ]

      response = Meal.changeset(params, foods)

      assert %Changeset{
               changes: %{
                 foods: [
                   %Changeset{
                     changes: %{description: "Arroz", weight: 100},
                     errors: [],
                     valid?: true
                   },
                   %Changeset{
                     changes: %{description: "Feijao", weight: 100},
                     errors: [],
                     valid?: true
                   }
                 ],
                 measurement_date: ~N[2023-02-28 23:00:07],
                 user_id: "957da868-ce7f-4eec-bcdc-97b8c992a60d"
               },
               valid?: true
             } = response
    end

    test "when there are some error, returns an invalid changeset" do
      params = build(:meal_params, %{"measurement_date" => nil, "user_id" => nil})
      foods = []

      response = Meal.changeset(params, foods)

      expected_response = %{
        foods: ["should have at least 1 item(s)"],
        measurement_date: ["can't be blank"],
        user_id: ["can't be blank"]
      }

      assert errors_on(response) == expected_response
    end
  end

  describe "build/1" do
    test "when all parameters is right, return a valid changeset" do
      params = build(:meal_params)

      foods = [
        build(:food_params),
        build(:food_params, %{"description" => "Feijao"})
      ]

      meal_changeset = Meal.changeset(params, foods)

      response = Meal.build(meal_changeset)

      assert {:ok,
              %Meal{
                id: nil,
                description: "Almoço",
                measurement_date: ~N[2023-02-28 23:00:07],
                user_id: "957da868-ce7f-4eec-bcdc-97b8c992a60d",
                foods: [
                  %Food{
                    id: nil,
                    description: "Arroz",
                    weight: 100,
                    meal_id: nil
                  },
                  %Food{
                    id: nil,
                    description: "Feijao",
                    weight: 100,
                    meal_id: nil
                  }
                ]
              }} = response
    end

    test "when there are some error, returns an invalid changeset" do
      params = build(:meal_params, %{"measurement_date" => nil, "user_id" => nil})
      foods = []

      meal_changeset = Meal.changeset(params, foods)

      {:error, response} = Meal.build(meal_changeset)

      expected_response = %{
        foods: ["should have at least 1 item(s)"],
        measurement_date: ["can't be blank"],
        user_id: ["can't be blank"]
      }

      assert errors_on(response) == expected_response
    end
  end
end
