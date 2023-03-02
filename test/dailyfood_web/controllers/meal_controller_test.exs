defmodule DailyfoodWeb.MealControllerTest do
  use DailyfoodWeb.ConnCase, async: true

  import Dailyfood.Factory

  describe "create/2" do
    setup %{conn: conn} do
      user = insert(:user)

      {:ok, conn: conn, user_id: user.id}
    end

    test "when all params are valid, creates the meal", %{conn: conn, user_id: user_id} do
      food1 = build(:food_params)
      food2 = build(:food_params, %{"description" => "Feijão"})
      food3 = build(:food_params, %{"description" => "Salada"})

      foods = [food1, food2, food3]

      params = build(:meal_params, %{"foods" => foods, "user_id" => user_id})

      response =
        conn
        |> post(Routes.meals_path(conn, :create), params)
        |> json_response(:created)

      assert %{
               "meal" => %{
                 "description" => "Almoço",
                 "foods" => [
                   %{"description" => "Arroz", "weight" => 100},
                   %{"description" => "Feijão", "weight" => 100},
                   %{"description" => "Salada", "weight" => 100}
                 ],
                 "id" => _meal_id,
                 "measurement_date" => "2023-02-28T23:00:07"
               },
               "message" => "Meal created"
             } = response
    end

    test "when there a invalid data, return a error", %{conn: conn, user_id: user_id} do
      params = %{"foods" => [], "user_id" => user_id}

      response =
        conn
        |> post(Routes.meals_path(conn, :create), params)
        |> json_response(:bad_request)

      expected_response = %{
        "message" => %{
          "description" => ["can't be blank"],
          "foods" => ["should have at least 1 item(s)"],
          "measurement_date" => ["can't be blank"]
        }
      }

      assert expected_response == response
    end

    test "when the a invalid user id, return a not found error", %{conn: conn} do
      food1 = build(:food_params)
      user_id = "0a9eabfb-6eba-4c78-8bab-549185274097"

      params = build(:meal_params, %{"foods" => [food1], "user_id" => user_id})

      response =
        conn
        |> post(Routes.meals_path(conn, :create), params)
        |> json_response(:not_found)

      expected_response = %{"message" => "User not found"}

      assert expected_response == response
    end
  end
end
