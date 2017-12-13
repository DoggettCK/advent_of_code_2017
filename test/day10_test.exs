defmodule Day10Test do
  use ExUnit.Case
  doctest Day10

  test "Day 10, Part 1" do
    assert Day10.part1([3, 4, 1, 5], 5) == 12

    actual = "test/fixtures/day10_input"
             |> File.read!()
             |> String.trim()
             |> String.split(",")
             |> Enum.map(&String.to_integer/1)
             |> Day10.part1()

    assert actual == 62238
  end

  test "Day 10, Part 2" do
    assert Day10.part2("") == "a2582a3a0e66e6e86e3812dcb672a272"
    assert Day10.part2("AoC 2017") == "33efeb34ea91902bb2f59c9920caa6cd"
    assert Day10.part2("1,2,3") == "3efbe78a8d82f29979031a4aa0b16a9d"
    assert Day10.part2("1,2,4") == "63960835bcdc130f0b66d7ff4f6a5a8e"


    actual = "test/fixtures/day10_input"
             |> File.read!()
             |> String.trim()
             |> Day10.part2()

    assert actual =="2b0c9cc0449507a0db3babd57ad9e8d8"
  end
end

