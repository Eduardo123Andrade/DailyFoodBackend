defmodule Dailyfood.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Dailyfood.Meals.Meal
  alias Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @required_params [:name, :email, :password]
  @update_params @required_params -- [:password]

  @derive {Jason.Encoder, only: [:id, :name, :email]}

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    has_many :meal, Meal

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params)
    |> changes(@required_params)
    |> put_password_hash()
  end

  def changeset(struct, params) do
    struct
    |> cast(params, @update_params)
    |> changes(@update_params)
  end

  defp changes(struct, fields) do
    struct
    |> validate_required(fields)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> validate_length(:password, min: 8)
    |> validate_length(:name, min: 5)
  end

  def build(changeset), do: apply_action(changeset, :create_user)

  defp put_password_hash(%Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Pbkdf2.add_hash(password))
  end

  defp put_password_hash(%Changeset{valid?: false} = changeset) do
    changeset
  end
end
