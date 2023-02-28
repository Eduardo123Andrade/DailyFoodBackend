defmodule Dailyfood.Factory do
  use ExMachina.Ecto, repo: Dailyfood.Repo

  alias Dailyfood.Foods.Food
  alias Dailyfood.Users.User

  def user_params_factory do
    %{
      "email" => "email@email",
      "password" => "123123123",
      "name" => "Stark"
    }
  end

  def user_factory do
    %User{
      email: "email@email",
      password: "123123123",
      name: "Stark",
      id: "957da868-ce7f-4eec-bcdc-97b8c992a60d"
    }
  end

  def food_params_factory do
    %{
      "description" => "Arroz",
      "weight" => 100
    }
  end

  def food_factory do
    %Food{
      description: "Arroz",
      weight: 100,
      id: "8bb494a5-cae7-4027-845f-5b2ba10c6677",
      meal_id: "11d9c69d-e05f-4952-8637-44fb7b3010a1"
    }
  end
end
