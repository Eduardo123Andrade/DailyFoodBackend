defmodule Dailyfood.Meals.Meal do
  use Ecto.Schema
  import Ecto.Changeset

  alias Dailyfood.Foods.Food
  alias Dailyfood.Users.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @required_params [:description, :measurement_date, :user_id]
  @derive {Jason.Encoder, only: [:id, :measurement_date, :description, :foods]}

  schema "meals" do
    field :description, :string
    field :measurement_date, :naive_datetime

    belongs_to :user, User

    has_many :foods, Food

    timestamps()
  end

  def changeset(params, foods) do
    %__MODULE__{}
    |> cast(params, @required_params)
    |> changes(@required_params, foods)
  end

  def build(changeset), do: apply_action(changeset, :create_meal)

  defp changes(struct, fields, foods) do
    foods_changeset = Enum.map(foods, &Food.changeset/1)

    struct
    |> put_assoc(:foods, foods_changeset)
    |> validate_required(fields)
    |> validate_length(:foods, min: 1)
  end
end
