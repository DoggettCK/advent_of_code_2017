defmodule Day10 do
  def part1(lengths, list_length \\ 256) do
    list_length
    |> KnotHash.new()
    |> KnotHash.twist_lengths(lengths)
    |> Map.get(:list)
    |> Enum.take(2)
    |> Enum.reduce(1, &Kernel.*/2)
  end

  @length_padding <<17, 31, 73, 47, 23>>

  def part2(input) do
    input
    |> Kernel.<>(@length_padding)
    |> KnotHash.hash()
  end
end
