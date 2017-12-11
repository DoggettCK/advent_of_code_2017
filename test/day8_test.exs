defmodule Day8Test do
  use ExUnit.Case
  doctest Day8

  test "Day 8, Part 1" do
    assert Day8.part1(~S{
      b inc 5 if a > 1
      a inc 1 if b < 5
      c dec -10 if a >= 1
      c inc -20 if c == 10
      }) == 1

    actual = "test/fixtures/day8_input"
             |> File.read!()
             |> Day8.part1()
    assert actual == 5849
  end

  test "Day 8, Part 2" do
    assert Day8.part2(~S{
      b inc 5 if a > 1
      a inc 1 if b < 5
      c dec -10 if a >= 1
      c inc -20 if c == 10
      }) == 10

    actual = "test/fixtures/day8_input"
             |> File.read!()
             |> Day8.part2()
    assert actual == 6702
  end
end
