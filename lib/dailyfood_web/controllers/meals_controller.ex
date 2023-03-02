defmodule DailyfoodWeb.MealsController do
  use DailyfoodWeb, :controller

  alias Dailyfood.Meals.Meal
  alias Plug.Conn

  alias DailyfoodWeb.{FallbackController}

  action_fallback FallbackController

  def create(%Conn{} = conn, params) do
    with {:ok, %Meal{} = meal} <- Dailyfood.meal_create(params) do
      conn
      |> put_status(:created)
      |> render("create.json", meal: meal)
    end
  end

  def show(%Conn{} = conn, params) do
    with {:ok, meals} <- Dailyfood.get_meals(params) do
      conn
      |> put_status(:ok)
      |> render("meals.json", %{meals: meals})
    end
  end
end
