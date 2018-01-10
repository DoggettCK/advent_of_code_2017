defmodule Day7Test do
  use ExUnit.Case
  doctest Day7

  test "Day 7, Part 1a" do
    actual = "test/fixtures/day7_short_input"
             |> File.read!()
             |> Day7.part1()
    assert actual == :tknk
  end

  test "Day 7, Part 1b" do
    actual = "test/fixtures/day7_input"
             |> File.read!()
             |> Day7.part1()
    assert actual == :hlhomy
  end

  test "Day 7, Part 2a" do
    actual = "test/fixtures/day7_short_input"
             |> File.read!()
             |> Day7.part2()
    assert actual == 60
  end

  test "Day 7, Part 2b" do
    actual = "test/fixtures/day7_input"
             |> File.read!()
             |> Day7.part2()
    assert actual == 1505
  end
end
