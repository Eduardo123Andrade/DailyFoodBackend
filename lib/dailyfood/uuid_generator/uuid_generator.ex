defmodule Dailyfood.UuidGenerator.UuidGenerator do
  def call do
    UUID.uuid4()
  end
end
