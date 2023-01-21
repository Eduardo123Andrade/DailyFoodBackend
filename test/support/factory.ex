defmodule Dailyfood.Factory do
  use ExMachina.Ecto, repo: Dailyfood.Repo

  def user_params_factory do
    %{
      "email" => "email@email",
      "password" => "123123123",
      "name" => "Stark"
    }
  end
end
