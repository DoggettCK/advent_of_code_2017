defmodule Day21Test do
  use ExUnit.Case
  doctest Day21

  test "Day 21, Part 1a" do
    actual = "test/fixtures/day21_short_input"
             |> File.read!()
             |> Day21.part1(2)
    assert actual == 12
  end

  test "Day 21, Part 1b" do
    actual = "test/fixtures/day21_input"
             |> File.read!()
             |> Day21.part1(5)
    assert actual == 142
  end

  test "Day 21, Part 2b" do
    actual = "test/fixtures/day21_input"
             |> File.read!()
             |> Day21.part1(18)
    assert actual == 1879071
  end
end

