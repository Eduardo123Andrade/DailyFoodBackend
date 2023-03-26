defmodule Dailyfood.Users.Get do
  alias Dailyfood.{Error, Repo}
  alias Dailyfood.Users.User

  def by_id(id) do
    User
    |> Repo.get(id)
    |> handle_user()
  end

  def by_email(email) do
    User
    |> Repo.get_by(email: email)
    |> handle_user()
  end

  defp handle_user(nil), do: {:error, Error.build_user_not_found_error()}
  defp handle_user(user), do: {:ok, user}
end
