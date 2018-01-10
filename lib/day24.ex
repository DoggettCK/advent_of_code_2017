defmodule Day24 do
  def part1(input) do
    input
    |> parse
    |> build_bridges({0, 0}, 0, :strongest)
    |> elem(0)
  end

  def part2(input) do
    input
    |> parse
    |> build_bridges({0, 0}, 0, :down_to_get_the_friction_ongest)
    |> elem(0)
  end

  defp build_bridges(available, {str, len}, port, sort_order) do
    usable = Enum.filter(available, fn {^port, _} -> true; {_, ^port} -> true; _ -> false end)

    if Enum.empty?(usable) do
      {str, len}
    else
      usable
      |> Enum.reduce([], fn
        {^port, b} = cur, acc ->
          acc ++ [build_bridges(available -- [cur], {str + strength(cur), len + 1}, b, sort_order)]
        {a, ^port} = cur, acc ->
          acc ++ [build_bridges(available -- [cur], {str + strength(cur), len + 1}, a, sort_order)]
      end)
      |> sort_bridges(sort_order)
      |> hd()
    end
  end

  defp sort_bridges(bridges, :strongest), do: Enum.sort(bridges, fn {str, _}, {str2, _} -> str > str2 end)
  defp sort_bridges(bridges, :down_to_get_the_friction_ongest) do
    Enum.sort(bridges, &sort_by_length_then_strength/2)
  end

  defp sort_by_length_then_strength({str1, len}, {str2, len}), do: str1 > str2
  defp sort_by_length_then_strength({_, len1}, {_, len2}), do: len1 > len2

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    line
    |> String.split("/")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  defp strength({a, b}), do: a + b
end
