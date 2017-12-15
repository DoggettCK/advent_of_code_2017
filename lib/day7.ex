defmodule Day7 do
  require Tree

  def part1(file_contents) do
    %Tree{ root: root } = parse(file_contents)

    root
  end

  def part2(file_contents) do
    file_contents
    |> parse()
  end

  def parse(file_contents) do
    file_contents
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
    |> Tree.new()
  end

  defp parse_line(line) do
    case String.split(line, " -> ") do
      [vertex_weight] -> parse_vertex_and_weight(vertex_weight) |> Tuple.append([])
      [vertex_weight, children] -> parse_vertex_and_weight(vertex_weight) |> Tuple.append(children |> String.split(", ") |> Enum.map(&String.to_atom/1))
    end
  end

  defp parse_vertex_and_weight(vertex_weight) do
    [lib, weight] = ~r{(\w+) \((\d+)\)}
                    |> Regex.scan(vertex_weight, capture: :all_but_first)
                    |> hd
    {String.to_atom(lib), String.to_integer(weight)}
  end
end
