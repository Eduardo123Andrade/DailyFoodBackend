defmodule DailyfoodWeb.UsersView do
  use DailyfoodWeb, :view

  alias Dailyfood.Users.User

  def render("create.json", %{user: %User{} = user}) do
    %{
      message: "User created",
      user: user
    }
  end

  def render("user.json", %{user: %User{} = user}), do: %{user: user}
end
