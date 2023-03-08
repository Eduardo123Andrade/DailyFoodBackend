defmodule DailyfoodWeb.MealControllerTest do
  alias Dailyfood.Meals.Meal
  alias Dailyfood.Meals.Create
  use DailyfoodWeb.ConnCase, async: true

  import Dailyfood.Factory

  defp create_meals() do
    user_id = "957da868-ce7f-4eec-bcdc-97b8c992a60d"
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

  describe "show/2" do
    setup %{conn: conn} do
      user = insert(:user)
      create_meals()

      {:ok, conn: conn, user_id: user.id}
    end

    test "when given a valid dates, return a list of meals", %{conn: conn, user_id: user_id} do
      initial_date = "2023-02-28"
      final_date = "2023-03-02"

      response =
        conn
        |> get(Routes.meals_path(conn, :show, initial_date, final_date, user_id))
        |> json_response(:ok)

      [first_meal | _] = response

      expected_response_length = 3

      assert expected_response_length == Enum.count(response)

      assert %{
               "meal" => %{
                 "description" => "Almoço",
                 "foods" => [
                   %{"description" => "Arroz", "weight" => 100},
                   %{"description" => "Arroz", "weight" => 100}
                 ],
                 "id" => _meal_id,
                 "measurement_date" => "2023-02-28T23:00:07"
               }
             } = first_meal
    end

    test "when given a invalid user id, return a error", %{conn: conn} do
      initial_date = "2023-02-28"
      final_date = "2023-03-02"
      user_id = "b4608c3d-eb45-4c4a-b6bc-474e080eeb9b"

      response =
        conn
        |> get(Routes.meals_path(conn, :show, initial_date, final_date, user_id))
        |> json_response(:not_found)

      expected_response = %{"message" => "User not found"}

      assert expected_response == response
    end
  end

  describe "generate_pdf/2" do
    setup %{conn: conn} do
      user = insert(:user)
      meal_ids = create_meals()

      {:ok, conn: conn, user_id: user.id, meal_ids: meal_ids}
    end

    test "when given a valid ids, return a list of meals", %{
      conn: conn,
      meal_ids: meal_ids,
      user_id: user_id
    } do
      params = %{"meal_ids" => meal_ids, "user_id" => user_id}

      response =
        conn
        |> post(Routes.meals_path(conn, :generate_pdf, params))
        |> json_response(:ok)

      %{"url" => url} = response
      includes_pdf = String.contains?(url, ".pdf")

      assert %{"url" => _url} = response
      assert true == includes_pdf
    end

    test "when given a meals list, return a error", %{conn: conn, user_id: user_id} do
      params = %{"meal_ids" => [], "user_id" => user_id}

      response =
        conn
        |> post(Routes.meals_path(conn, :generate_pdf), params)
        |> json_response(:not_found)

      expected_response = %{"message" => "Meals not found"}

      assert expected_response == response
    end

    test "when given a invalid user id, return a error", %{conn: conn, meal_ids: meal_ids} do
      user_id = "b4608c3d-eb45-4c4a-b6bc-474e080eeb9b"
      params = %{"meal_ids" => meal_ids, "user_id" => user_id}

      response =
        conn
        |> post(Routes.meals_path(conn, :generate_pdf, params))
        |> json_response(:not_found)

      expected_response = %{"message" => "User not found"}

      assert expected_response == response
    end
  end
end
