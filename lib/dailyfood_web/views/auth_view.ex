defmodule DailyfoodWeb.AuthView do
  use DailyfoodWeb, :view

  alias Dailyfood.Users.User

  def render("login.json", %{token: token, user: %User{} = user}) do
    %{
      message: "User logged",
      user: user,
      token: token
    }
  end

  # def render("user.json", %{user: %User{} = user}), do: %{user: user}
end
