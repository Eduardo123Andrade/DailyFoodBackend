defmodule Dailyfood.Users.UpdateTest do
  use Dailyfood.DataCase, async: true

  import Dailyfood.Factory

  alias Dailyfood.Error
  alias Dailyfood.Users.{Create, Update, User}

  describe "call/1" do
    test "when all params are valid, return a user with updated data" do
      params = build(:user_params)

      {:ok, user} = Create.call(params)

      updated_params = %{"id" => user.id, "name" => "Lord Stark"}

      updated_user = Update.call(updated_params)

      assert {:ok, %User{name: "Lord Stark"}} = updated_user
    end

    test "when are invalid param, return a error" do
      params = build(:user_params)

      {:ok, user} = Create.call(params)

      updated_params = %{"id" => user.id, "email" => "email"}

      response = Update.call(updated_params)

      expected_response = %{
        email: ["has invalid format"]
      }

      assert {:error, %Error{result: changeset, status: :bad_request}} = response
      assert errors_on(changeset) == expected_response
    end

    test "when id not found, return a error" do
      id = "957da868-ce7f-4eec-bcdc-97b8c992a60d"
      response = Update.call(%{"id" => id})

      assert {:error, %Error{status: :not_found, result: "User not found"}} = response
    end
  end
end
