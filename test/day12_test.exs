defmodule Day12Test do
  use ExUnit.Case
  doctest Day12

  test "Day 12, Part 1" do
    assert Day12.part1(~S{
      0 <-> 2
      1 <-> 1
      2 <-> 0, 3, 4
      3 <-> 2, 4
      4 <-> 2, 3, 6
      5 <-> 6
      6 <-> 4, 5}) == 6

    actual = "test/fixtures/day12_input"
             |> File.read!()
             |> Day12.part1()
    assert actual == 306
  end

  test "Day 12, Part 2" do
    assert Day12.part2(~S{
      0 <-> 2
      1 <-> 1
      2 <-> 0, 3, 4
      3 <-> 2, 4
      4 <-> 2, 3, 6
      5 <-> 6
      6 <-> 4, 5}) == 2

    actual = "test/fixtures/day12_input"
             |> File.read!()
             |> Day12.part2()
    assert actual == 200
  end
end

