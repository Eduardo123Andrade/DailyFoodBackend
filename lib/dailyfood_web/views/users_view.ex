defmodule DailyfoodWeb.UsersView do
  use DailyfoodWeb, :view

  alias Dailyfood.Users.User

  def render("create.json", %{token: token, user: %User{} = user}) do
    %{
      message: "User created",
      user: user,
      token: token
    }
  end

  def render("user.json", %{user: %User{} = user}), do: %{user: user}
end
