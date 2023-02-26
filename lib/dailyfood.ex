defmodule Dailyfood do
  alias Dailyfood.Users.Create, as: UserCreate
  alias Dailyfood.Users.Get, as: UserGet
  alias Dailyfood.Users.Update, as: UserUpdate

  defdelegate user_create(params), to: UserCreate, as: :call
  defdelegate get_user_by_id(id), to: UserGet, as: :by_id
  defdelegate update_user(params), to: UserUpdate, as: :call
end
