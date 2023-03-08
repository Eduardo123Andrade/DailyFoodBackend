defmodule Dailyfood.PdfGenerator.ZeroToLeftTest do
  use ExUnit.Case

  alias Dailyfood.PdfGenerator.ZeroToLeft

  describe "call/1" do
    test "when given a valid number, return this number with 0 on lef" do
      number = 3
      response = ZeroToLeft.call(number)

      expected_response = "03"
      assert expected_response == response
    end
  end
end
