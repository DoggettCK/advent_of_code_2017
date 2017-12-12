defmodule Day9 do
  def part1(line) do
    line
    |> score_line(0, 0, false, 0)
    |> elem(0)
  end

  def part2(line) do
    line
    |> score_line(0, 0, false, 0)
    |> elem(1)
  end

  defp score_line("", _level, score, in_garbage, garbage_count), do: { score, garbage_count }
  defp score_line("!" <> <<_::binary-size(1), rest::binary>>, level, score, in_garbage, garbage_count), do: score_line(rest, level, score, in_garbage, garbage_count)
  defp score_line("<" <> rest, level, score, false, garbage_count), do: score_line(rest, level, score, true, garbage_count)
  defp score_line(">" <> rest, level, score, true, garbage_count), do: score_line(rest, level, score, false, garbage_count)
  defp score_line("{" <> rest, level, score, false, garbage_count), do: score_line(rest, level + 1, score, false, garbage_count)
  defp score_line("}" <> rest, level, score, false, garbage_count), do: score_line(rest, level - 1, score + level, false, garbage_count)
  defp score_line(<<_::binary-size(1), rest::binary>>, level, score, true, garbage_count), do: score_line(rest, level, score, true, garbage_count + 1)
  defp score_line(<<_::binary-size(1), rest::binary>>, level, score, in_garbage, garbage_count), do: score_line(rest, level, score, in_garbage, garbage_count)
end
