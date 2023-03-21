defmodule DailyfoodWeb.Auth.Guardian do
  alias Dailyfood.Users.User
  alias Dailyfood.Users.Get, as: UserGet
  use Guardian, otp_app: :dailyfood

  def subject_for_token(%User{id: id}, _claims) do
    IO.inspect(id, label: "subject_for_token")
    {:ok, id}
  end

  def resource_from_claims(claims) do
    claims
    |> Map.get("sub")
    |> UserGet.by_id()
  end
end
