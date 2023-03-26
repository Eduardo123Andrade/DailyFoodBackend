defmodule DailyfoodWeb.UsersControllerTest do
  use DailyfoodWeb.ConnCase, async: true
  alias DailyfoodWeb.Auth.Guardian

  import Dailyfood.Factory

  describe "show/2" do
    setup %{conn: conn} do
      user = insert(:user)
      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      {:ok, conn: conn, user: user}
    end

    test "when theres a valid id, return a user", %{conn: conn} do
      response =
        conn
        |> get(Routes.users_path(conn, :show))
        |> json_response(:ok)

      assert %{
               "user" => %{
                 "email" => "email@email",
                 "id" => _id,
                 "name" => "Stark"
               }
             } = response
    end

    test "where user not found, return a error", %{conn: conn, user: user} do
      id = "957da868-ce7f-4eec-bcdc-97b8c992a60a"
      user = Map.put(user, :id, id)
      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      response =
        conn
        |> get(Routes.users_path(conn, :show))
        |> json_response(:unauthorized)

      assert %{"message" => "Invalid credentials"} = response
    end
  end

  describe "update2" do
    setup %{conn: conn} do
      user = insert(:user)
      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      {:ok, conn: conn, user: user}
    end

    test "when all parameters are valid, return a updated user", %{conn: conn} do
      update_params = build(:user_params, %{"name" => "Lord Stark"})

      response =
        conn
        |> put(Routes.users_path(conn, :update), update_params)
        |> json_response(:ok)

      assert %{
               "user" => %{
                 "email" => "email@email",
                 "id" => _id,
                 "name" => "Lord Stark"
               }
             } = response
    end

    test "when some params are invalid, return a error", %{conn: conn} do
      update_params = build(:user_params, %{"name" => "Edu"})

      response =
        conn
        |> put(Routes.users_path(conn, :update), update_params)
        |> json_response(:bad_request)

      expected_response = %{"message" => %{"name" => ["should be at least 5 character(s)"]}}

      assert expected_response == response
    end

    test "where user not found, return a error", %{conn: conn, user: user} do
      id = "957da868-ce7f-4eec-bcdc-97b8c992a60a"
      user = Map.put(user, :id, id)
      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      response =
        conn
        |> get(Routes.users_path(conn, :show))
        |> json_response(:unauthorized)

      assert %{"message" => "Invalid credentials"} = response
    end
  end
end
