defmodule Dailyfood.PdfGenerator.PdfGeneratorTest do
  use Dailyfood.DataCase, async: true

  import Dailyfood.Factory

  alias Dailyfood.Error
  alias Dailyfood.Meals.{Create, Meal}
  alias Dailyfood.PdfGenerator.PDFGenerator
  alias Dailyfood.Users.Create, as: UserCreate

  defp create_meals(user_id) do
    meal_ids = []
    food1 = build(:food_params)
    food2 = build(:food_params)
    food3 = build(:food_params, %{"description" => "Carne"})
    food4 = build(:food_params, %{"description" => "Salada"})

    meal_params =
      build(:meal_params, %{
        "foods" => [food1, food2],
        "measurement_date" => ~N[2023-02-28 23:00:07],
        "user_id" => user_id
      })

    {:ok, %Meal{id: meal_id}} = Create.call(meal_params)

    meal_ids = meal_ids ++ [meal_id]

    meal_params =
      build(:meal_params, %{
        "foods" => [food1, food3],
        "measurement_date" => ~N[2023-03-01 23:00:07],
        "user_id" => user_id
      })

    {:ok, %Meal{id: meal_id}} = Create.call(meal_params)

    meal_ids = meal_ids ++ [meal_id]

    meal_params =
      build(:meal_params, %{
        "foods" => [food1, food4],
        "measurement_date" => ~N[2023-03-02 23:00:07],
        "user_id" => user_id
      })

    {:ok, %Meal{id: meal_id}} = Create.call(meal_params)

    meal_ids = meal_ids ++ [meal_id]

    meal_params =
      build(:meal_params, %{
        "foods" => [food2, food4],
        "measurement_date" => ~N[2023-03-03 23:00:07],
        "user_id" => user_id
      })

    {:ok, %Meal{id: meal_id}} = Create.call(meal_params)

    meal_ids = meal_ids ++ [meal_id]

    meal_params =
      build(:meal_params, %{
        "foods" => [food4, food3],
        "measurement_date" => ~N[2023-03-04 23:00:07],
        "user_id" => user_id
      })

    {:ok, %Meal{id: meal_id}} = Create.call(meal_params)

    meal_ids = meal_ids ++ [meal_id]

    meal_ids
  end

  describe "call/1" do
    setup do
      user_param = build(:user_params)
      {:ok, user} = UserCreate.call(user_param)

      meal_ids = create_meals(user.id)
      {:ok, user_id: user.id, meal_ids: meal_ids}
    end

    test "when given a valid params, return a html url", %{meal_ids: meal_ids, user_id: user_id} do
      params = %{"meal_ids" => meal_ids, "user_id" => user_id}

      {:ok, url} = PDFGenerator.call(params)

      includes_pdf = String.contains?(url, ".pdf")

      assert true == includes_pdf
    end

    test "when given a invalid user id, return an error", %{meal_ids: meal_ids} do
      user_id = "8bb494a5-cae7-4027-845f-5b2ba10c6677"
      params = %{"meal_ids" => meal_ids, "user_id" => user_id}

      response = PDFGenerator.call(params)

      expected_response = {:error, %Error{status: :not_found, result: "User not found"}}

      assert expected_response == response
    end

    test "when given a invalid meals id, return an error", %{user_id: user_id} do
      params = %{"meal_ids" => [], "user_id" => user_id}

      response = PDFGenerator.call(params)

      expected_response = {:error, %Error{status: :not_found, result: "Meals not found"}}

      assert expected_response == response
    end
  end
end
