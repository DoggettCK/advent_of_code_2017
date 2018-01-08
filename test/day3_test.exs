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

  test "Day 3, Part 2" do
    assert Day3.part2(1) == 2
    assert Day3.part2(12) == 23
    assert Day3.part2(23) == 25
    assert Day3.part2(1024) == 1968
    assert Day3.part2(368078) == 369601
  end
end

