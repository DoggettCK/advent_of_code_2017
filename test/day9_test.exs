defmodule Day9Test do
  use ExUnit.Case
  doctest Day9

  test "Day 9, Part 1" do

    assert Day9.part1("{}") == 1
    assert Day9.part1("{{{}}}") == 6
    assert Day9.part1("{{},{}}") == 5
    assert Day9.part1("{{{},{},{{}}}}") == 16
    assert Day9.part1("{<a>,<a>,<a>,<a>}") == 1
    assert Day9.part1("{{<ab>},{<ab>},{<ab>},{<ab>}}") == 9
    assert Day9.part1("{{<!!>},{<!!>},{<!!>},{<!!>}}") == 9
    assert Day9.part1("{{<a!>},{<a!>},{<a!>},{<ab>}}") == 3

    actual = "test/fixtures/day9_input"
             |> File.read!()
             |> Day9.part1()
    assert actual == 9662
  end

  test "Day 9, Part 2" do
    assert Day9.part2("<>") == 0
    assert Day9.part2("<random characters>") == 17
    assert Day9.part2("<<<<>") == 3
    assert Day9.part2("<{!>}>") == 2
    assert Day9.part2("<!!>") == 0
    assert Day9.part2("<!!!>>") == 0
    assert Day9.part2(~S(<{o"i!a,<{i<a>)) == 10

    actual = "test/fixtures/day9_input"
            |> File.read!()
            |> Day9.part2()
    assert actual == 4903
  end
end
