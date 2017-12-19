defmodule Day17Test do
  use ExUnit.Case
  doctest Day17

  test "Day 17, Part 1" do
    assert Day17.part1(3) == 638
    assert Day17.part1(382) == 1561
  end

  test "Day 17, Part 2" do
    assert Day17.part2(3) == 1222153
    assert Day17.part2(382) == 33454823
  end
end

