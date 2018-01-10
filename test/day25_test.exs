defmodule Day25Test do
  use ExUnit.Case
  doctest Day25

  test "Day 25, Part 1a" do
    actual = "test/fixtures/day25_short_input"
             |> File.read!()
             |> Day25.part1()
    assert actual == 3
  end

  test "Day 25, Part 1b" do
    actual = "test/fixtures/day25_input"
             |> File.read!()
             |> Day25.part1()
    assert actual == 4230
  end
end
