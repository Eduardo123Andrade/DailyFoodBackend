defmodule DailyfoodWeb.AuthController do
  use DailyfoodWeb, :controller

  alias DailyfoodWeb.Auth.Guardian
  alias Dailyfood.Users.User
  alias Plug.Conn

  alias DailyfoodWeb.{Auth.Guardian, FallbackController}

  action_fallback FallbackController

  def sing_up(%Conn{} = conn, params) do
    with {:ok, %User{} = user} <- Dailyfood.user_create(params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render("sing_up.json", token: token, user: user)
    end
  end

  def login(%Conn{} = conn, params) do
    with {:ok, %User{} = user, token} <- Guardian.authenticate(params) do
      conn
      |> put_status(:ok)
      |> render("login.json", token: token, user: user)
    end
  end
end
