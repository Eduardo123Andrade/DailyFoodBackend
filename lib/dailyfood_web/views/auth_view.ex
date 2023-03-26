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

  def render("sing_up.json", %{token: token, user: %User{} = user}) do
    %{
      message: "User created",
      user: user,
      token: token
    }
  end
end
