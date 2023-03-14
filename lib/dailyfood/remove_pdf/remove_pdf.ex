defmodule Dailyfood.RemovePdf.RemovePdf do
  alias Dailyfood.Error
  require Logger

  def call(file_path) do
    file_path
    |> File.exists?()
    |> delete_file(file_path)
  end

  defp delete_file(true, file_path), do: GenServer.cast(:delete_pdf_server, {:delete, file_path})

  defp delete_file(false, _), do: {:error, Error.build_not_found("file not found")}
end
