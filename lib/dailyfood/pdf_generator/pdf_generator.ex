defmodule Dailyfood.PdfGenerator.PDFGenerator do
  alias Dailyfood.UuidGenerator.UuidGenerator
  alias Dailyfood.PdfGenerator.HtmlGenerator

  def call(%{"meal_ids" => meal_ids, "user_id" => user_id}) do
    {:ok, meals} = Dailyfood.get_meals_by_ids(%{"meal_ids" => meal_ids, "user_id" => user_id})

    html = HtmlGenerator.call(%{"meals" => meals, "user_id" => user_id})
    filename = UuidGenerator.call()
    IO.inspect(filename)

    html
    |> PdfGenerator.generate(page_size: "A5", encoding: :utf8)
    |> move_to_pdf_folder(filename)
    |> delete_temp_files()

    {:ok, "PDFs/#{filename}.pdf"}
  end

  defp move_to_pdf_folder({:ok, filename}, output_filename) do
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
