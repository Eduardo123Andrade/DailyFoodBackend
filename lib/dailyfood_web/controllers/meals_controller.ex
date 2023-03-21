defmodule DailyfoodWeb.MealsController do
  use DailyfoodWeb, :controller

  alias Dailyfood.Meals.Meal
  # alias Dailyfood.Users.User
  alias Plug.Conn

  alias DailyfoodWeb.FallbackController

  action_fallback FallbackController

  def create(%Conn{} = conn, params) do
    # %User{id: id} = Guardian.Plug.current_resource(conn)
    # IO.inspect(id, label: "TEST")
    # Conn.resp(conn, :ok, "test")
    with {:ok, %Meal{} = meal} <- Dailyfood.meal_create(params) do
      conn
      |> put_status(:created)
      |> render("create.json", meal: meal)
    end
  end

  def show(%Conn{} = conn, params) do
    with {:ok, meals} <- Dailyfood.get_meals_by_date(params) do
      conn
      |> put_status(:ok)
      |> render("meals.json", %{meals: meals})
    end
  end

  def generate_pdf(%Conn{} = conn, params) do
    with {:ok, file_path} <- Dailyfood.generate_meals_pdf(params) do
      conn
      |> put_status(:ok)
      |> json(%{"url" => file_path})
    end
  end
end
