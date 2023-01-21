defmodule Dailyfood.Users.Create do
  # alias Dailyfood.Users
  alias Dailyfood.Repo
  alias Dailyfood.Users.User

  def call(params) do
    params
    |> User.changeset()
    |> Repo.insert()
  end
end
