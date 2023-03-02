defmodule DailyfoodWeb.UsersControllerTest do
  use DailyfoodWeb.ConnCase, async: true

  import Dailyfood.Factory

  describe "create/2" do
    test "when all params are valid, creates the user", %{conn: conn} do
      params = build(:user_params)

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:created)

      assert %{
               "message" => "User created",
               "user" => %{
                 "email" => "email@email",
                 "id" => _id,
                 "name" => "Stark"
               }
             } = response
    end

    test "when theres is some error, returns the error", %{conn: conn} do
      params = %{}

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:bad_request)

      expected_response = %{
        "message" => %{
          "name" => ["can't be blank"],
          "email" => ["can't be blank"],
          "password" => ["can't be blank"]
        }
      }

      assert expected_response == response
    end
  end

  describe "show/2" do
    setup %{conn: conn} do
      user = insert(:user)
      # {:ok, token, _claims} = Guardian.encode_and_sign(user)
      # conn = put_req_header(conn, "authorization", "Bearer #{token}")
      {:ok, conn: conn, id: user.id}
    end

    test "when theres a valid id, return a user", %{conn: conn, id: id} do
      response =
        conn
        |> get(Routes.users_path(conn, :show, id))
        |> json_response(:ok)

      assert %{
               "user" => %{
                 "email" => "email@email",
                 "id" => _id,
                 "name" => "Stark"
               }
             } = response
    end

    test "where user not found, return a error", %{conn: conn} do
      id = "957da868-ce7f-4eec-bcdc-97b8c992a60a"

      response =
        conn
        |> get(Routes.users_path(conn, :show, id))
        |> json_response(:not_found)

      assert %{"message" => "User not found"} = response
    end

    test "where given a invalid id, return a error", %{conn: conn} do
      id = "invalid uuid"

      response =
        conn
        |> get(Routes.users_path(conn, :show, id))
        |> json_response(:bad_request)

      assert %{"message" => "Invalid UUID"} = response
    end
  end

  describe "update2" do
    setup %{conn: conn} do
      user = insert(:user)
      # {:ok, token, _claims} = Guardian.encode_and_sign(user)
      # conn = put_req_header(conn, "authorization", "Bearer #{token}")
      {:ok, conn: conn, id: user.id}
    end

    test "when all parameters are valid, return a updated user", %{conn: conn, id: id} do
      update_params = build(:user_params, %{"name" => "Lord Stark"})

      response =
        conn
        |> put(Routes.users_path(conn, :update, id), update_params)
        |> json_response(:ok)

      expected_response = %{
        "user" => %{
          "email" => "email@email",
          "id" => id,
          "name" => "Lord Stark"
        }
      }

      assert expected_response == response
    end

    test "when some params are invalid, return a error", %{conn: conn, id: id} do
      update_params = build(:user_params, %{"name" => "Edu"})

      response =
        conn
        |> put(Routes.users_path(conn, :update, id), update_params)
        |> json_response(:bad_request)

      expected_response = %{"message" => %{"name" => ["should be at least 5 character(s)"]}}

      assert expected_response == response
    end

    test "where user not found, return a error", %{conn: conn} do
      id = "957da868-ce7f-4eec-bcdc-97b8c992a60a"

      response =
        conn
        |> put(Routes.users_path(conn, :update, id))
        |> json_response(:not_found)

      assert %{"message" => "User not found"} = response
    end

    test "where given a invalid id, return a error", %{conn: conn} do
      id = "invalid uuid"

      response =
        conn
        |> put(Routes.users_path(conn, :update, id))
        |> json_response(:bad_request)

      assert %{"message" => "Invalid UUID"} = response
    end
  end
end
