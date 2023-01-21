defmodule Dailyfood.Users.CreateTest do
  use Dailyfood.DataCase, async: true

  # import Mox
  import Dailyfood.Factory

  alias Dailyfood.Error
  alias Dailyfood.Users.{Create, User}

  describe "call/1" do
    test "when all params are valid, return the user" do
      params = build(:user_params)

      response = Create.call(params)

      assert {:ok, %User{id: _id, name: "Stark", email: "email@email"}} = response
    end

    test "when there invalid params, return an error" do
      params = build(:user_params, %{"password" => "123", "age" => 15})

      response = Create.call(params)

      expected_response = %{
        password: ["should be at least 8 character(s)"]
      }

      assert {:error, %Error{result: changeset, status: :bad_request}} = response
      assert errors_on(changeset) == expected_response
    end
  end
end
