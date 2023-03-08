defmodule Dailyfood.Meal.GetTest do
  use Dailyfood.DataCase, async: true

  import Dailyfood.Factory

  alias Dailyfood.Error
  alias Dailyfood.Meals.{Create, Get, Meal}
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

  describe "by_date/1" do
    setup _ do
      user_param = build(:user_params)
      {:ok, user} = UserCreate.call(user_param)

      create_meals(user.id)
      {:ok, user_id: user.id}
    end

    test "when given two valid dates, return a list of meals", %{user_id: user_id} do
      start_date = "2023-02-28"
      end_date = "2023-03-03"

      params = %{"initial_date" => start_date, "final_date" => end_date, "user_id" => user_id}

      {:ok, meals} = Get.by_date(params)

      [first_meal | _] = meals

      expected_length = 4

      assert Enum.count(meals) == expected_length
      assert %Meal{foods: foods} = first_meal
      assert Enum.count(foods) >= 1
    end

    test "when a invalid user id is given, return a error" do
      user_id = "48101fa5-dd26-4629-9b01-a7e0f3c31590"
      start_date = "2023-02-28"
      end_date = "2023-03-03"

      params = %{"initial_date" => start_date, "final_date" => end_date, "user_id" => user_id}

      response = Get.by_date(params)

      assert {:error, %Error{result: "User not found", status: :not_found}} = response
    end
  end

  describe "by_ids/1" do
    setup _ do
      user_param = build(:user_params)
      {:ok, user} = UserCreate.call(user_param)

      meal_ids = create_meals(user.id)
      {:ok, user_id: user.id, meal_ids: meal_ids}
    end

    test "when given a list with valid ids, return a list of meal", %{
      user_id: user_id,
      meal_ids: meal_ids
    } do
      params = %{"meal_ids" => meal_ids, "user_id" => user_id}

      {:ok, meals} = Get.by_ids(params)

      [%Meal{} = first_meal | _] = meals

      expected_length = 5

      assert Enum.count(meals) == expected_length
      assert %Meal{foods: foods} = first_meal
      assert Enum.count(foods) >= 1
    end

    test "when a invalid user id is given, return a error", %{meal_ids: meal_ids} do
      user_id = "48101fa5-dd26-4629-9b01-a7e0f3c31590"
      params = %{"meal_ids" => meal_ids, "user_id" => user_id}

      response = Get.by_ids(params)

      assert {:error, %Error{result: "User not found", status: :not_found}} = response
    end
  end
end
