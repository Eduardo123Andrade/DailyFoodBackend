defmodule Dailyfood.PdfGenerator.HtmlGenerator do
  alias Dailyfood.Meals.Meal
  alias Dailyfood.PdfGenerator.RenderMeals
  alias Dailyfood.PdfGenerator.ZeroToLeft
  alias Dailyfood.Users.User

  def call(%{meals: meals, user: user}) do
    generate_pdf(user, meals)
  end

  defp generate_pdf(%User{} = user, [%Meal{} = meal | _] = meals) do
    %Meal{measurement_date: start_date} = meal
    %Meal{measurement_date: last_date} = List.last(meals)

    html = """
    <body>
      <div style="height: 65px; display: flex; flex-direction: row;">
        <div style="background-color: brown;height: 100%;width: 5%;">
        </div>
        <div style="width: 100%;">
          <div style="padding: 5px 10px; border-style: solid; border-width: 1px; margin-bottom: 1px;">
            <label>
              #{user.name}
            </label>
          </div>
          <div style="padding: 5px 10px; border-style: solid; border-width: 1px; margin-bottom: 1px;">
            <label>
              #{format_date(start_date)} - #{format_date(last_date)}
            </label>
          </div>
        </div>
      </div>
      <div style="margin-top: 10px;">
        #{RenderMeals.call(meals)}
      </div>
    </body>
    """

    {:ok, html}
  end

  defp format_date(%NaiveDateTime{} = date) do
    "#{ZeroToLeft.call(date.day)}/#{ZeroToLeft.call(date.month)}/#{ZeroToLeft.call(date.year)}"
  end
end
