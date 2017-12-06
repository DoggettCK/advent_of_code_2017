defmodule Day1Test do
  use ExUnit.Case
  doctest Day1

  test "Day 1, Part 1" do
    assert Day1.part1("1122") == 3
    assert Day1.part1("1111") == 4
    assert Day1.part1("1234") == 0
    assert Day1.part1("91212129") == 9

    actual = "test/fixtures/day1_input"
             |> File.read!()
             |> String.trim()
             |> Day1.part1()

    assert actual == 1182
  end

  test "Day 1, Part 2" do
    assert Day1.part2("1212") == 6
    assert Day1.part2("1221") == 0
    assert Day1.part2("123123") == 12
    assert Day1.part2("12131415") == 4

    actual = "test/fixtures/day1_input"
             |> File.read!()
             |> String.trim()
             |> Day1.part2()

    assert actual == 1152
  end
end
