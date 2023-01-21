defmodule Dailyfood.Users.Create do
  # alias Dailyfood.Users
  alias Dailyfood.Error
  alias Dailyfood.Repo
  alias Dailyfood.Users.User

  def call(params) do
    user_changeset = User.changeset(params)

    with {:ok, %User{}} <- User.build(user_changeset),
         {:ok, %User{}} = user <- Repo.insert(user_changeset) do
      user
    else
      {:error, %Error{}} = error -> error
      {:error, result} -> {:error, Error.build(:bad_request, result)}
    end
  end
end
