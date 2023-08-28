defmodule CandleTest do
  use ExUnit.Case
  doctest Candle

  test "greets the world" do
    assert Candle.hello() == :world
  end
end
