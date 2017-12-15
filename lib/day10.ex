defmodule Day10 do
  def part1(lengths, list_length \\ 256) do
    list_length
    |> KnotHash.new()
    |> KnotHash.twist_lengths(lengths)
    |> Map.get(:list)
    |> Enum.take(2)
    |> Enum.reduce(1, &Kernel.*/2)
  end

  def part2(input) do
    KnotHash.hash(input)
  end
end
