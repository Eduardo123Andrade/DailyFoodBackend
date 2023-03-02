defmodule Dailyfood.Meal.CreateTest do
  use Dailyfood.DataCase, async: true

  import Dailyfood.Factory

  alias Dailyfood.Error
  alias Dailyfood.Foods.Food
  alias Dailyfood.Meals.{Create, Meal}
  alias Dailyfood.Users.Create, as: UserCreate

  describe "call/1" do
    setup _ do
      {:ok, user} =
        :user_params
        |> build()
        |> UserCreate.call()

      {:ok, user_id: user.id}
    end

    test "when all params is valid, return a the meals", %{user_id: user_id} do
      food1 = build(:food_params)
      food2 = build(:food_params, %{"description" => "Feijão"})

      foods = [food1, food2]

      meals = build(:meal_params, %{"foods" => foods, "user_id" => user_id})

      response = Create.call(meals)
      {:ok, %{id: meals_id}} = response

      assert {:ok,
              %Meal{
                id: ^meals_id,
                description: "Almoço",
                measurement_date: ~N[2023-02-28 23:00:07],
                user_id: ^user_id,
                foods: [
                  %Food{
                    description: "Arroz",
                    weight: 100,
                    meal_id: ^meals_id
                  },
                  %Food{
                    description: "Feijão",
                    weight: 100,
                    meal_id: ^meals_id
                  }
                ]
              }} = response
    end

    test "when there an error, return a error", %{user_id: user_id} do
      meals = build(:meal_params, %{"foods" => [], "user_id" => user_id})

      response = Create.call(meals)

      expected_response = %{
        foods: ["should have at least 1 item(s)"]
      }

      assert {:error, %Error{result: changeset, status: :bad_request}} = response
      assert errors_on(changeset) == expected_response
    end

    test "when user not found, return a error" do
      user_id = "48101fa5-dd26-4629-9b01-a7e0f3c31590"
      food1 = build(:food_params)
      food2 = build(:food_params, %{"description" => "Feijão"})

      foods = [food1, food2]

      meals = build(:meal_params, %{"foods" => foods, "user_id" => user_id})

      response = Create.call(meals)

      assert {:error, %Error{result: "User not found", status: :not_found}} = response
    end
  end
end
