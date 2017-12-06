defmodule Day2Test do
  use ExUnit.Case
  doctest Day2

  test "Day 2, Part 1" do
    assert Day2.part1([
      [5, 1, 9, 5],
      [7, 5, 3],
      [2, 4, 6, 8]
    ]) == 18

    actual = "test/fixtures/day2_input"
             |> Day2.parse_file()
             |> Day2.part1()

    assert actual == 41919
  end

  test "Day 2, Part 2" do
    assert Day2.part2([
      [5, 9, 2, 8],
      [9, 4, 7, 3],
      [3, 8, 6, 5]
    ]) == 9

    actual = "test/fixtures/day2_input"
             |> Day2.parse_file()
             |> Day2.part2()

    assert actual == 303
  end
end

