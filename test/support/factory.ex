defmodule Dailyfood.Factory do
  alias Dailyfood.Users.User
  use ExMachina.Ecto, repo: Dailyfood.Repo

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
end
