defmodule Day18Test do
  use ExUnit.Case
  doctest Day18

  test "Day 18, Part 1a" do
    input = ~S{
      set a 1
      add a 2
      mul a a
      mod a 5
      snd a
      set a 0
      rcv a
      jgz a -1
      set a 1
      jgz a -2
    }

    assert Day18.part1(input) == 4
  end

  test "Day 18, Part 1b" do
    actual = "test/fixtures/day18_input"
             |> File.read!()
             |> Day18.part1()
    assert actual == 3423
  end

  test "Day 18, Part 2a" do
    input = ~S{
      snd 1
      snd 2
      snd p
      rcv a
      rcv b
      rcv c
      rcv d
    }

    assert Day18.part2(input) == 3
  end

  test "Day 18, Part 2b" do
    actual = "test/fixtures/day18_input"
             |> File.read!()
             |> Day18.part2()
    assert actual == 7493
  end
end

