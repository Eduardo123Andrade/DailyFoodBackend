defmodule Dailyfood.Users.UserTest do
  use Dailyfood.DataCase, async: true

  import Dailyfood.Factory

  alias Dailyfood.Users.User
  alias Ecto.Changeset

  describe "changeset/1" do
    test "when all params are valid, return a valid changeset" do
      params = build(:user_params)

      response = User.changeset(params)

      assert %Changeset{changes: %{name: "Stark"}, valid?: true} = response
    end

    test "when there are some error, returns an invalid changeset" do
      params = build(:user_params, %{"password" => "123"})

      response = User.changeset(params)

      expected_response = %{
        password: ["should be at least 8 character(s)"]
      }

      assert errors_on(response) == expected_response
    end
  end
end
