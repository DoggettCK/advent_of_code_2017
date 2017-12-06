defmodule Day6Test do
  use ExUnit.Case
  doctest Day6

  test "Day 6, Part 1" do
    assert Day6.part1([0, 2, 7, 0]) == 5

    actual = "test/fixtures/day6_input"
             |> File.read!()
             |> String.trim()
             |> String.split(~r{\s+})
             |> Enum.map(&String.to_integer/1)
             |> Day6.part1()
    assert actual == 12841
  end

  test "Day 6, Part 2" do
    assert Day6.part2([0, 2, 7, 0]) == 4

    actual = "test/fixtures/day6_input"
             |> File.read!()
             |> String.trim()
             |> String.split(~r{\s+})
             |> Enum.map(&String.to_integer/1)
             |> Day6.part2()
    assert actual == 8038
  end
end

