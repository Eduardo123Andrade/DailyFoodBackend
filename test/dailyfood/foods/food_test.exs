defmodule Dailyfood.Foods.FoodTest do
  use Dailyfood.DataCase, async: true

  import Dailyfood.Factory

  alias Dailyfood.Foods.Food
  alias Ecto.Changeset

  describe "changeset/1" do
    test "when all params are valid, return a valid changeset" do
      params = build(:food_params)

      response = Food.changeset(params)

      assert %Changeset{
               changes: %{
                 description: "Arroz",
                 weight: 100
               },
               valid?: true
             } = response
    end

    test "when there are some error, returns an invalid changeset" do
      params = build(:food_params, %{"weight" => "0"})

      response = Food.changeset(params)

      expected_response = %{
        weight: ["must be greater than 0"]
      }

      assert errors_on(response) == expected_response
    end
  end
end
