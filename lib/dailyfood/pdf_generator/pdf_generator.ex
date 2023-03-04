defmodule Dailyfood.PdfGenerator.PdfGenerator do
  alias Dailyfood.UuidGenerator.UuidGenerator

  def call(_params) do
    html = "<body>Olar</body>"
    filename = UuidGenerator.call()

    html
    |> PdfGenerator.generate(page_size: "A5")
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
