defmodule Day7Test do
  use ExUnit.Case
  doctest Day7

  test "Day 7, Part 1" do
    assert Day7.part1(~S{
      pbga (66)
      xhth (57)
      ebii (61)
      havc (66)
      ktlj (57)
      fwft (72) -> ktlj, cntj, xhth
      qoyq (66)
      padx (45) -> pbga, havc, qoyq
      tknk (41) -> ugml, padx, fwft
      jptl (61)
      ugml (68) -> gyxo, ebii, jptl
      gyxo (61)
      cntj (57)}) == :tknk

    actual = "test/fixtures/day7_input"
             |> File.read!()
             |> Day7.part1()
    assert actual == :hlhomy
  end
end
