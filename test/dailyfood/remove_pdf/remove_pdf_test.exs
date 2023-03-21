defmodule Dailyfood.RemovePdf.RemovePdfTest do
  use ExUnit.Case, async: true

  alias Dailyfood.Error
  alias Dailyfood.RemovePdf.RemovePdf

  describe "call/1" do
    setup do
      file_path = "PDFs/file.txt"
      File.write(file_path, "Hellow")
      {:ok, file_path: file_path}
    end

    test "when a valid path is given delete a file", %{file_path: file_path} do
      file_exists = File.exists?(file_path)

      expected_response = true

      assert expected_response == file_exists

      response = RemovePdf.call(file_path)
      :timer.sleep(12_000)

      file_exists = File.exists?(file_path)

      expected_response = false

      assert expected_response == file_exists
      assert :ok == response
    end

    test "when a file doesnt exist, return a error" do
      file_path = "PDFs/file2.txt"

      response = RemovePdf.call(file_path)

      expected_response = {:error, %Error{status: :not_found, result: "file not found"}}

      assert expected_response == response
    end
  end
end
