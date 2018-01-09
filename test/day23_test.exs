defmodule Day23Test do
  use ExUnit.Case
  doctest Day23

  test "Day 23, Part 1" do
    actual = "test/fixtures/day23_input"
             |> File.read!()
             |> Day23.part1()
    assert actual == 6241
  end

  test "Day 23, Part 2" do
    assert Day23.part2() == 909
  end
end

