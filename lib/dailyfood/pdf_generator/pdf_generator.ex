defmodule Dailyfood.PdfGenerator.PdfGenerator do
  # import PdfGenerator

  def call() do
    html = "<body>Olar</body>"

    html
    |> PdfGenerator.generate(page_size: "A5")
    |> move_to_pdf_folder()
    |> delete_temp_files()

    {:ok, "PDFs/test.pdf"}
  end

  defp move_to_pdf_folder({:ok, filename}) do
    {:ok, pdf_content} = File.read(filename)
    File.write("PDFs/test.pdf", pdf_content)

    {:ok, filename}
  end

  defp delete_temp_files({:ok, filename}) do
    IO.inspect(filename, label: "FILE_NAME")

    File.rm_rf(filename)

    filename
    |> String.replace(".pdf", ".html")
    |> File.rm_rf()
  end
end
