defmodule Dailyfood.Error do
  @keys [:status, :result]

  @enforce_keys @keys

  defstruct @keys

  def build(status, result) do
    %__MODULE__{
      status: status,
      result: result
    }
  end

  def build_not_found(message), do: build(:not_found, message)
  def build_user_not_found_error, do: build_not_found("User not found")
  def build_item_not_found_error, do: build_not_found("Item not found")
  def build_meals_not_found_error, do: build_not_found("Meals not found")
end
