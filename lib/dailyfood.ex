defmodule Dailyfood do
  alias Dailyfood.Meals.Create, as: MealCreate
  alias Dailyfood.Meals.Get, as: MealGet

  alias Dailyfood.PdfGenerator.PDFGenerator

  alias Dailyfood.Users.Create, as: UserCreate
  alias Dailyfood.Users.Get, as: UserGet
  alias Dailyfood.Users.Update, as: UserUpdate
  alias Dailyfood.UuidGenerator.UuidGenerator

  defdelegate user_create(params), to: UserCreate, as: :call
  defdelegate get_user_by_id(id), to: UserGet, as: :by_id
  defdelegate get_user_by_email(email), to: UserGet, as: :by_email
  defdelegate update_user(params), to: UserUpdate, as: :call

  defdelegate meal_create(params), to: MealCreate, as: :call
  defdelegate get_meals_by_date(params), to: MealGet, as: :by_date
  defdelegate get_meals_by_ids(params), to: MealGet, as: :by_ids
  defdelegate generate_meals_pdf(params), to: PDFGenerator, as: :call
  defdelegate generate_uuid(), to: UuidGenerator, as: :call
end
