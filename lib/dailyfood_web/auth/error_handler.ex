defmodule DailyfoodWeb.Auth.ErrorHandler do
  import Plug.Conn

  alias Plug.Conn
  alias Guardian.Plug.ErrorHandler

  @behaviour ErrorHandler

  def auth_error(%Conn{} = conn, {_error, _reason} = test, _opts) do
    body = Jason.encode!(%{message: handle_error(test)})

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(:unauthorized, body)
    |> halt()
  end

  defp handle_error({:no_resource_found, _reason}), do: "Invalid credentials"

  defp handle_error({error, _reason}), do: to_string(error)
end
