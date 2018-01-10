defmodule Day24Test do
  use ExUnit.Case
  doctest Day24

  test "Day 24, Part 1a" do
    actual = "test/fixtures/day24_short_input"
             |> File.read!()
             |> Day24.part1()
    assert actual == 31
  end

  test "Day 24, Part 1b" do
    actual = "test/fixtures/day24_input"
             |> File.read!()
             |> Day24.part1()
    assert actual == 1906
  end

  test "Day 24, Part 2a" do
    actual = "test/fixtures/day24_short_input"
             |> File.read!()
             |> Day24.part2()
    assert actual == 19
  end

  test "Day 24, Part 2b" do
    actual = "test/fixtures/day24_input"
             |> File.read!()
             |> Day24.part2()
    assert actual == 1824
  end
end

