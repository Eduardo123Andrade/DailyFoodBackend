defmodule Dailyfood.Users.DeleteTest do
  use Dailyfood.DataCase, async: true

  import Dailyfood.Factory

  alias Dailyfood.Error
  alias Dailyfood.Users.{Delete, User}

  describe "call/1" do
    test "when exists a user with id, delete a user" do
      id = "957da868-ce7f-4eec-bcdc-97b8c992a60d"

      insert(:user)

      founded_user = Delete.call(id)

      assert {:ok,
              %User{
                id: "957da868-ce7f-4eec-bcdc-97b8c992a60d",
                name: "Stark"
              }} = founded_user
    end

    test "when id not found, return a error" do
      id = "957da868-ce7f-4eec-bcdc-97b8c992a60a"
      response = Delete.call(id)

      assert {:error, %Error{status: :not_found, result: "User not found"}} = response
    end
  end
end
