defmodule BarkbotTest do
  use ExUnit.Case
  doctest Barkbot

  test "greets the world" do
    assert Barkbot.hello() == :world
  end
end
