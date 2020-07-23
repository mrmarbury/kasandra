defmodule KasandraTest do
  use ExUnit.Case
  doctest Kasandra

  test "greets the world" do
    assert Kasandra.hello() == :world
  end
end
