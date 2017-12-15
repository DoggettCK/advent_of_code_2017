defmodule Day13Test do
  use ExUnit.Case
  doctest Day13

  test "Day 13, Part 1" do
    assert Day13.part1(~S{
      0: 3
      1: 2
      4: 4
      6: 4}) == 24

    actual = "test/fixtures/day13_input"
             |> File.read!()
             |> Day13.part1()
    assert actual == 1316
  end

  test "Day 13, Part 2" do
    assert Day13.part2(~S{
      0: 3
      1: 2
      4: 4
      6: 4}) == 10

      # Test on actual input takes ~33s
      #actual = "test/fixtures/day13_input"
      #|> File.read!()
      #|> Day13.part2()
      #assert actual == 3840052
  end
end
