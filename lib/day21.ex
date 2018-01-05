defmodule Day21.Common do
  def pattern_to_table(pattern) when is_binary(pattern) do
    pattern
    |> String.trim()
    |> String.split("/", trim: true)
    |> Enum.map(fn row -> row |> String.trim() |> String.graphemes() end)
  end

  def table_to_pattern(table) do
    table
    |> Enum.map(&Enum.join/1)
    |> Enum.join("/")
  end
end

defmodule Day21.RuleParser do
  import Day21.Common

  @default_rules %{
    "../.." => ".../.../...",
    ".../.../..." => "..../..../..../...."
  }

  def parse(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.reduce(@default_rules, &parse_rule_line/2)
  end

  defp parse_rule_line(line, rules) do
    [rule, output] = line
                     |> String.trim()
                     |> String.split(" => ")
    rule
    |> variations()
    |> Enum.map(&table_to_pattern/1)
    |> Enum.reduce(rules, fn rule, map -> Map.put(map, rule, output) end)
  end

  defp variations(pattern) do
    rotated = pattern
              |> pattern_to_table()
              |> rotations()

    horizontal_variations = rotated
                            |> Enum.map(&flip_horizontal/1)
                            |> Kernel.++(rotated)

    horizontal_variations
    |> Enum.map(&flip_vertical/1)
    |> Kernel.++(horizontal_variations)
    |> Enum.uniq()
  end

  defp rotations([[_, _], [_, _]] = base), do: do_rotations([base], 3)
  defp rotations([[_, _, _], [_, _, _], [_, _, _]] = base), do: do_rotations([base], 3)

  defp do_rotations(rotations, 0), do: Enum.reverse(rotations)
  defp do_rotations([[[a, b], [c, d]] | _] = rotations, remaining) do
    do_rotations([[[c, a], [d, b]] | rotations], remaining - 1)
  end
  defp do_rotations([[[a, b, c], [d, e, f], [g, h, i]] | _] = rotations, remaining) do
    do_rotations([[[g, d, a], [h, e, b], [i, f, c]] | rotations], remaining - 1)
  end

  defp flip_horizontal([[a, b], [c, d]]), do: [[b, a], [d, c]]
  defp flip_horizontal([[a, b, c], [d, e, f], [g, h, i]]), do: [[c, b, a], [f, e, d], [i, h, g]]

  defp flip_vertical([[a, b], [c, d]]), do: [[c, d], [a, b]]
  defp flip_vertical([[a, b, c], [d, e, f], [g, h, i]]), do: [[g, h, i], [d, e, f], [a, b, c]]
end

defmodule Day21 do
  import Day21.Common

  @start_state ".#./..#/###"

  def part1(input, iterations) do
    rules = Day21.RuleParser.parse(input)

    @start_state
    |> process(rules, iterations)
    |> char_count()
  end

  defp char_count(pattern, char \\ "#") do
    pattern
    |> String.split("", trim: true)
    |> Enum.group_by(&(&1))
    |> Map.get(char, [])
    |> length()
  end

  defp process(board, _rules, 0), do: board
  defp process(board, rules, remaining), do: board |> process_board(rules) |> process(rules, remaining - 1)

  defp process_board(board, rules) do
    board
    |> chunkify_pattern()
    |> Enum.map(fn row ->
      Enum.map(row, fn chunk ->
        Map.get(rules, chunk)
      end)
    end)
    |> rebuild_pattern()
  end

  @doc """
  Convert a string pattern representing a table into a list of patterns representing NxN chunks of that table.
  """
  defp chunkify_pattern(pattern) do
    pattern
    |> pattern_to_table()
    |> split_table()
  end

  defp split_table(table) when table |> length |> rem(2) == 0, do: split_table(table, 2)
  defp split_table(table) when table |> length |> rem(3) == 0, do: split_table(table, 3)
  defp split_table(table, n) do
    table
    |> Enum.chunk(n)
    |> Enum.map(fn row -> split_rows(row, n) end)
  end

  defp split_rows(rows, n) do
    rows
    |> Enum.map(fn n_rows -> Enum.chunk(n_rows, n) end)
    |> Enum.zip()
    |> Enum.map(fn tuple -> tuple |> Tuple.to_list |> table_to_pattern() end)
  end

  # Rebuild table
  defp rebuild_pattern(chunk_rows) do
    chunk_rows
    |> Enum.map(fn row ->
      row
      |> Enum.map(fn chunk -> String.split(chunk, "/") end)
      |> Enum.zip
      |> Enum.map(fn tuple -> tuple |> Tuple.to_list |> Enum.join end)
      |> Enum.join("/")
    end)
    |> Enum.join("/")
  end
end
