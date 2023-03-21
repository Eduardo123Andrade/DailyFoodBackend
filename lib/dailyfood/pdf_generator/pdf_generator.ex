defmodule Dailyfood.PdfGenerator.PDFGenerator do
  alias Dailyfood.Error
  alias Dailyfood.Meals
  alias Dailyfood.PdfGenerator.HtmlGenerator
  alias Dailyfood.RemovePdf.RemovePdf
  alias Dailyfood.UuidGenerator.UuidGenerator

  def call(%{"user_id" => user_id} = params) do
    with {:ok, user} <- Dailyfood.get_user_by_id(user_id),
         {:ok, meals} <- Dailyfood.get_meals_by_ids(params),
         {:ok, html_content} <- generate_pdf_content(meals, user),
         {:ok, filename} <- PdfGenerator.generate(html_content, page_size: "A5", encoding: :utf8),
         {:ok, output_path} <- move_to_pdf_folder(filename),
         {:ok, _} <- delete_temp_files(filename) do
      RemovePdf.call(output_path)
      {:ok, output_path}
    end
  end

  defp generate_pdf_content([], _user_id) do
    {:error, Error.build_meals_not_found_error()}
  end

  defp generate_pdf_content([%Meals.Meal{} = _meal | _] = meals, user) do
    HtmlGenerator.call(%{meals: meals, user: user})
  end

  defp move_to_pdf_folder(filename) do
    output_filename = UuidGenerator.call()

    {:ok, pdf_content} = File.read(filename)
    output_path = "PDFs/#{output_filename}.pdf"

    response = File.write(output_path, pdf_content)

    {response, output_path}
  end

  defp delete_temp_files(filename) do
    File.rm_rf(filename)

    filename
    |> String.replace(".pdf", ".html")
    |> File.rm_rf()
  end
end
