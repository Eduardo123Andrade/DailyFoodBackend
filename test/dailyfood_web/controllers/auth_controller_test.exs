defmodule DailyfoodWeb.AuthControllerTest do
  use DailyfoodWeb.ConnCase, async: true

  import Dailyfood.Factory

  describe "sing_up/2" do
    test "when all params are valid, return a user with token", %{conn: conn} do
      params = build(:user_params)

      response =
        conn
        |> post(Routes.auth_path(conn, :sing_up, params))
        |> json_response(:created)

      assert %{
               "message" => "User created",
               "token" => _token,
               "user" => %{
                 "email" => "email@email",
                 "id" => _id,
                 "name" => "Stark"
               }
             } = response
    end

    test "when given a invalid params, return a error", %{conn: conn} do
      params = %{}

      response =
        conn
        |> post(Routes.auth_path(conn, :sing_up, params))
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

    test "when the email already exists, return a error, return a error", %{conn: conn} do
      params = build(:user_params)

      post(conn, Routes.auth_path(conn, :sing_up, params))

      response =
        conn
        |> post(Routes.auth_path(conn, :sing_up, params))
        |> json_response(:bad_request)

      expected_response = %{"message" => %{"email" => ["has already been taken"]}}

      assert expected_response == response
    end
  end

  describe "login/2" do
    test "when given a valid params, return a user with token", %{conn: conn} do
      params = build(:user_params)

      %{"user" => user} =
        conn
        |> post(Routes.auth_path(conn, :sing_up, params))
        |> json_response(:created)

      params = %{"email" => user["email"], "password" => "123123123"}

      response =
        conn
        |> post(Routes.auth_path(conn, :login, params))
        |> json_response(:ok)

      assert %{
               "message" => "User logged",
               "token" => _token,
               "user" => %{
                 "email" => "email@email",
                 "id" => _id,
                 "name" => "Stark"
               }
             } = response
    end

    test "when email not found, return a error", %{conn: conn} do
      params = %{"email" => "invalid_email@email", "password" => "123123123"}

      response =
        conn
        |> post(Routes.auth_path(conn, :login, params))
        |> json_response(:not_found)

      expected_response = %{"message" => "User not found"}

      assert expected_response == response
    end

    test "when given invalid params, return a error", %{conn: conn} do
      params = %{}

      response =
        conn
        |> post(Routes.auth_path(conn, :login, params))
        |> json_response(:bad_request)

      expected_response = %{"message" => "Invalid or missing params"}

      assert expected_response == response
    end
  end
end
