defmodule Dailyfood.RemovePdf.Sever do
  use GenServer
  require Logger

  @one_hour_in_millisecond 10_000

  def start_link(_initial_stack) do
    GenServer.start_link(__MODULE__, %{}, name: :delete_pdf_server)
  end

  @impl true
  def init(state) do
    Logger.info("Delete PDF started...")
    {:ok, state}
  end

  @impl true
  def handle_cast({:delete, file_path}, state) do
    Process.send_after(self(), {:delete_file, file_path}, @one_hour_in_millisecond)
    {:noreply, state}
  end

  @impl true
  def handle_info({:delete_file, file_path}, state) do
    File.rm_rf(file_path)
    Logger.info("Deleted PDF #{file_path}")
    {:noreply, state}
  end
end
