defmodule Dailyfood.Users.Get do
  alias Dailyfood.{Error, Repo}
  alias Dailyfood.Users.User

  def by_id(id) do
    case Repo.get(User, id) do
      nil -> {:error, Error.build_user_not_found_error()}
      user -> {:ok, user}
    end
  end
end
