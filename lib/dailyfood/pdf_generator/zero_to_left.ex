defmodule Dailyfood.PdfGenerator.ZeroToLeft do
  def call(num), do: String.pad_leading(to_string(num), 2, "0")
end
