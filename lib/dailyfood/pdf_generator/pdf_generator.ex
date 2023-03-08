defmodule Dailyfood.PdfGenerator.PDFGenerator do
  alias Dailyfood.Meals
  alias Dailyfood.Error
  alias Dailyfood.UuidGenerator.UuidGenerator
  alias Dailyfood.PdfGenerator.HtmlGenerator

  def call(%{"user_id" => user_id} = params) do
    with {:ok, user} <- Dailyfood.get_user_by_id(user_id),
         {:ok, meals} <- Dailyfood.get_meals_by_ids(params),
         {:ok, html_content} <- generate_pdf_content(meals, user),
         {:ok, filename} <- PdfGenerator.generate(html_content, page_size: "A5", encoding: :utf8) do
      output_filename = UuidGenerator.call()

      filename
      |> move_to_pdf_folder(output_filename)
      |> delete_temp_files()

      {:ok, "PDFs/#{output_filename}.pdf"}
    end
  end

  defp generate_pdf_content([], _user_id) do
    {:error, Error.build_meals_not_found_error()}
  end

  defp generate_pdf_content([%Meals.Meal{} = _meal | _] = meals, user) do
    HtmlGenerator.call(%{meals: meals, user: user})
  end

  defp move_to_pdf_folder(filename, output_filename) do
    {:ok, pdf_content} = File.read(filename)

    File.write("PDFs/#{output_filename}.pdf", pdf_content)

    {:ok, filename}
  end

  defp delete_temp_files({:ok, filename}) do
    File.rm_rf(filename)

    filename
    |> String.replace(".pdf", ".html")
    |> File.rm_rf()
  end
end
