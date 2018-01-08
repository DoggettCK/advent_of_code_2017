defmodule Day22Test do
  use ExUnit.Case
  doctest Day22

  test "Day 22, Part 1a" do
    file_contents = "test/fixtures/day22_short_input"
                    |> File.read!()

    assert Day22.part1(file_contents, 7) == 5
    assert Day22.part1(file_contents, 70) == 41
    assert Day22.part1(file_contents, 10_000) == 5587
  end

  test "Day 22, Part 1b" do
    actual = "test/fixtures/day22_input"
             |> File.read!()
             |> Day22.part1(10_000)
    assert actual == 5322
  end

  test "Day 22, Part 2a" do
    file_contents = "test/fixtures/day22_short_input"
                    |> File.read!()

    assert Day22.part2(file_contents, 7) == 1
    assert Day22.part2(file_contents, 100) == 26
    assert Day22.part2(file_contents, 10_000_000) == 2511944
  end

  test "Day 22, Part 2b" do
    actual = "test/fixtures/day22_input"
             |> File.read!()
             |> Day22.part2(10_000_000)
    assert actual == 2512079
  end
end

