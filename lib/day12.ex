defmodule Day12 do
  def part1(input) do
    input
    |> parse
    |> :digraph_utils.strong_components()
    |> Enum.filter(&(0 in &1))
    |> hd
    |> length
  end

  def part2(input) do
    input
    |> parse
    |> :digraph_utils.strong_components()
    |> length
  end

  def parse(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
    |> Enum.reduce(:digraph.new, &add_vert_and_neighbors/2)
  end

  defp add_vert_and_neighbors({vert, neighbors}, graph) do
    :digraph.add_vertex(graph, vert)

    Enum.reduce(neighbors, graph, fn neighbor, g ->
      :digraph.add_vertex(g, neighbor)
      :digraph.add_edge(g, neighbor, vert)
      :digraph.add_edge(g, vert, neighbor)
      g
    end)

    graph
  end

  defp parse_line(line) do
    [h | t] = line
              |> String.trim()
              |> String.replace(" <-> ", ", ")
              |> String.split(", ")
              |> Enum.map(&String.to_integer/1)
    {h, t}
  end
end
