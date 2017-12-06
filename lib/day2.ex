defmodule Day2 do
  def part1(number_lists) do
    number_lists
    |> Enum.map(&get_line_diffs/1)
    |> Enum.sum()
  end

  def part2(number_lists) do
    number_lists
    |> Enum.map(&find_evenly_divisible/1)
    |> Enum.sum()
  end

  def parse_file(filename) do
    filename
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&line_to_ints/1)
  end

  defp line_to_ints(line) do
    line
    |> String.split("\t")
    |> Enum.map(&String.to_integer/1)
  end

  defp get_line_diffs(numbers), do: do_line_diffs(numbers, 0, 0)
  defp do_line_diffs([], min, max), do: max - min
  defp do_line_diffs([h | t], 0, 0), do: do_line_diffs(t, h, h)
  defp do_line_diffs([h | t], min, max) when h < min, do: do_line_diffs(t, h, max)
  defp do_line_diffs([h | t], min, max) when h > max, do: do_line_diffs(t, min, h)
  defp do_line_diffs([_ | t], min, max), do: do_line_diffs(t, min, max)

  defp find_evenly_divisible([]), do: 0
  defp find_evenly_divisible([_]), do: 1
  defp find_evenly_divisible(numbers) do
    for x <- numbers, y <- numbers, x > y, div(x, y) * y == x do
      # May need x >= y
      div(x, y)
    end |> hd
  end
end
