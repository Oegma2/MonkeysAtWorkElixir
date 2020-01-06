defmodule MonkeysAtWorkElixirTest do
  use ExUnit.Case
  doctest MonkeysAtWorkElixir

  test "greets the world" do
    assert MonkeysAtWorkElixir.hello() == :world
  end
end
