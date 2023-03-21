defmodule DailyfoodWeb.UsersController do
  use DailyfoodWeb, :controller

  alias Dailyfood.Users.User
  alias Plug.Conn

  alias DailyfoodWeb.{Auth.Guardian, FallbackController}

  action_fallback FallbackController

  def create(%Conn{} = conn, params) do
    with {:ok, %User{} = user} <- Dailyfood.user_create(params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render("create.json", token: token, user: user)
    end
  end

  def show(%Conn{} = conn, %{"id" => id}) do
    with {:ok, %User{} = user} <- Dailyfood.get_user_by_id(id) do
      conn
      |> put_status(:ok)
      |> render("user.json", user: user)
    end
  end

  def update(%Conn{} = conn, params) do
    with {:ok, %User{} = user} <- Dailyfood.update_user(params) do
      conn
      |> put_status(:ok)
      |> render("user.json", user: user)
    end
  end
end
