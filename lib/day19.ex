defmodule Day19 do
  def part1(input) do
    input
    |> Maze.parse()
    |> Maze.solve()
    |> elem(0)
  end

  def part2(input) do
    input
    |> Maze.parse()
    |> Maze.solve()
    |> elem(1)
  end
end
