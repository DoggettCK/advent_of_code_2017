defmodule Day3Test do
  use ExUnit.Case
  doctest Day3

  test "Day 3, Part 1" do
    assert Day3.part1(1) == 0
    assert Day3.part1(12) == 3
    assert Day3.part1(23) == 2
    assert Day3.part1(1024) == 31
    assert Day3.part1(368078) == 371
  end
end

