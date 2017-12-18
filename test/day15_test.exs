defmodule Day15Test do
  use ExUnit.Case
  doctest Day15

  # Long-running
  #@tag timeout: 600000
  #test "Day 15, Part 1" do
    #assert Day15.part1(65, 8921) == 588
    #assert Day15.part1(591, 393) == 619
  #end

  @tag timeout: 600000
  test "Day 15, Part 2" do
    assert Day15.part2(65, 8921) == 309
    assert Day15.part2(591, 393) == 290
  end
end

