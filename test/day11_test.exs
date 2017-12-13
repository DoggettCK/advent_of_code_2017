defmodule Day11Test do
  use ExUnit.Case
  doctest Day11

  test "Day 11, Part 1" do
    assert Day11.part1("ne,ne,ne") == 3
    assert Day11.part1("ne,ne,sw,sw") == 0
    assert Day11.part1("ne,ne,s,s") == 2
    assert Day11.part1("se,sw,se,sw,sw") == 3

    actual = "test/fixtures/day11_input"
             |> File.read!()
             |> Day11.part1()
    assert actual == 764
  end

  test "Day 11, Part 2" do
    assert Day11.part2("ne,ne,ne") == 3
    assert Day11.part2("ne,ne,sw,sw") == 2
    assert Day11.part2("ne,ne,s,s") == 2
    assert Day11.part2("se,sw,se,sw,sw") == 3

    actual = "test/fixtures/day11_input"
             |> File.read!()
             |> Day11.part2()
    assert actual == 1532
  end
end

