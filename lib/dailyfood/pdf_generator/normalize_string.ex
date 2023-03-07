defmodule Dailyfood.PdfGenerator.NormalizeString do
  def call(value), do: value |> String.normalize(:nfd) |> String.replace(~r/[^A-z\s]/u, "")
end
