defmodule DailyfoodWeb.Auth.ErrorHandler do
  alias Plug.Conn
  alias Guardian.Plug.ErrorHandler

  @behaviour ErrorHandler

  def auth_error(%Conn{} = conn, {error, _reason}, _opts) do
    body = Jason.encode!(%{message: to_string(error)})
    Conn.send_resp(conn, :unauthorized, body)
  end
end
