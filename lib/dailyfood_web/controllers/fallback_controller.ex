defmodule DailyfoodWeb.FallbackController do
  use DailyfoodWeb, :controller

  alias Dailyfood.Error
  alias DailyfoodWeb.ErrorView

  def call(conn, {:error, %Error{status: status, result: result}}) do
    conn
    |> put_status(status)
    |> put_view(ErrorView)
    |> render("error.json", result: result)
  end
end
