defmodule Dailyfood.RemovePdf.RemovePdf do
  require Logger

  def call(file_path), do: GenServer.cast(:delete_pdf_server, {:delete, file_path})
end
