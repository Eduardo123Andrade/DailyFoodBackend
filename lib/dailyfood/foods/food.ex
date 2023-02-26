defmodule Dailyfood.Foods.Food do
  use Ecto.Schema
  import Ecto.Changeset

  alias Dailyfood.Meals.Meal

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @required_params [:description, :weight]
  @derive {Jason.Encoder, only: [:description, :weight]}

  schema "foods" do
    field :description, :string
    field :weight, :integer

    belongs_to :meal, Meal

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params)
    |> changes(@required_params)
  end

  defp changes(struct, fields) do
    struct
    |> validate_required(fields)
    |> validate_number(:weight, greater_than: 0)
  end
end
