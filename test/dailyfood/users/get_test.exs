defmodule Dailyfood.Users.GetTest do
  use Dailyfood.DataCase, async: true

  import Dailyfood.Factory

  alias Dailyfood.Error
  alias Dailyfood.Users.{Get, User}

  describe "by_id/1" do
    test "when exists a user with this id, return a user" do
      id = "957da868-ce7f-4eec-bcdc-97b8c992a60d"

      insert(:user)

      founded_user = Get.by_id(id)

      assert {:ok,
              %User{
                id: "957da868-ce7f-4eec-bcdc-97b8c992a60d",
                name: "Stark"
              }} = founded_user
    end

    test "when id not found, return a error" do
      id = "957da868-ce7f-4eec-bcdc-97b8c992a60a"
      response = Get.by_id(id)

      assert {:error, %Error{status: :not_found, result: "User not found"}} = response
    end
  end
end
