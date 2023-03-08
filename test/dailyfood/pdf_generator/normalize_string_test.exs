defmodule Dailyfood.PdfGenerator.NormalizeStringTest do
  alias Dailyfood.PdfGenerator.NormalizeString
  use ExUnit.Case

  describe "call/1" do
    test "when given a string with special character, return the pure string" do
      string = "Almoço"

      response = NormalizeString.call(string)

      expected_response = "Almoco"

      assert expected_response == response
    end
  end
end
