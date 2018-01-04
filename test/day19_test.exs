defmodule Day19Test do
  use ExUnit.Case
  doctest Day19

  test "Day 19, Part 1a" do
    actual = "test/fixtures/day19_short_input"
             |> File.read!()
             |> Day19.part1()
    assert actual == "ABCDEF"
  end

  test "Day 19, Part 1b" do
    actual = "test/fixtures/day19_input"
             |> File.read!()
             |> Day19.part1()
    assert actual == "QPRYCIOLU"
  end

  test "Day 19, Part 2a" do
    actual = "test/fixtures/day19_short_input"
             |> File.read!()
             |> Day19.part2()
    assert actual == 38
  end

  test "Day 19, Part 2b" do
    actual = "test/fixtures/day19_input"
             |> File.read!()
             |> Day19.part2()
    assert actual == 16162
  end
end

