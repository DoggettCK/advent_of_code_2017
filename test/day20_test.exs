defmodule Day20Test do
  use ExUnit.Case
  doctest Day20

  test "Day 20, Part 1a" do
    input = ~S{
      p=< 3,0,0>, v=< 2,0,0>, a=<-1,0,0>
      p=< 4,0,0>, v=< 0,0,0>, a=<-2,0,0>
    }

    assert Day20.part1(input) == 0
  end

  test "Day 20, Part 1b" do
    actual = "test/fixtures/day20_input"
             |> File.read!()
             |> Day20.part1()
    assert actual == 344
  end

  test "Day 20, Part 2a" do
    input = ~S{
      p=<-6,0,0>, v=< 3,0,0>, a=< 0,0,0>    
      p=<-4,0,0>, v=< 2,0,0>, a=< 0,0,0>
      p=<-2,0,0>, v=< 1,0,0>, a=< 0,0,0>
      p=< 3,0,0>, v=<-1,0,0>, a=< 0,0,0>
    }

    assert Day20.part2(input, 4) == 1
  end

  test "Day 20, Part 2b" do
    actual = "test/fixtures/day20_input"
             |> File.read!()
             |> Day20.part2()
    assert actual == 404
  end
end

