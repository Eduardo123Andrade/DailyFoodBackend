defmodule Dailyfood.Users.Update do
  alias Dailyfood.{Error, Repo}
  alias Dailyfood.Users.User

  def call(%{"id" => id} = params) do
    case Repo.get(User, id) do
      nil -> {:error, Error.build_user_not_found_error()}
      user -> do_update(user, params)
    end
  end

  defp do_update(%User{} = user, params) do
    user
    |> User.changeset(params)
    |> Repo.update()
    |> handle_insert()
  end

  defp handle_insert({:ok, %User{}} = result), do: result

  defp handle_insert({:error, result}) do
    {:error, Error.build(:bad_request, result)}
  end
end
