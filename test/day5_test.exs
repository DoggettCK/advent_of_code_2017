defmodule Day5Test do
  use ExUnit.Case
  doctest Day5

  test "Day 5, Part 1" do
    assert Day5.part1([0, 3, 0, 1, -3]) == 5
    actual = "test/fixtures/day5_input"
             |> Day5.read_lines()
             |> Day5.part1()
    assert actual == 318883
  end

  test "Day 5, Part 2" do
    assert Day5.part2([0, 3, 0, 1, -3]) == 10
    actual = "test/fixtures/day5_input"
             |> Day5.read_lines()
             |> Day5.part2()
    assert actual == 23948711
  end
end
