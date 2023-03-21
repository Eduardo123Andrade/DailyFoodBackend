defmodule DailyfoodWeb.UsersController do
  use DailyfoodWeb, :controller

  alias Dailyfood.Users.User
  alias Plug.Conn

  alias DailyfoodWeb.FallbackController

  action_fallback FallbackController

  def show(%Conn{} = conn, _params) do
    %User{id: id} = Guardian.Plug.current_resource(conn)

    with {:ok, %User{} = user} <- Dailyfood.get_user_by_id(id) do
      conn
      |> put_status(:ok)
      |> render("user.json", user: user)
    end
  end

  def update(%Conn{} = conn, params) do
    %User{id: id} = Guardian.Plug.current_resource(conn)
    updated_params = Map.put(params, "id", id)

    with {:ok, %User{} = user} <- Dailyfood.update_user(updated_params) do
      conn
      |> put_status(:ok)
      |> render("user.json", user: user)
    end
  end
end
