defmodule Day16Test do
  use ExUnit.Case
  doctest Day16

  test "Day 16, Part 1" do
    assert Day16.part1("s1,x3/4,pe/b", "abcde") == "baedc"

    actual = "test/fixtures/day16_input"
             |> File.read!()
             |> Day16.part1()

    assert actual == "padheomkgjfnblic"
  end

  test "Day 16, Part 2a" do
    assert Day16.part2("s1,x3/4,pe/b", "abcde") == "baedc"
  end

  test "Day 16, Part 2b" do
    actual = "test/fixtures/day16_input"
             |> File.read!()
             |> Day16.part2()

    assert actual == "bfcdeakhijmlgopn"
  end
end

