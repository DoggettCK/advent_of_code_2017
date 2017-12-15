defmodule Day14 do
  use Bitwise

  @graph_size 128
  def part1(input) do
    0..(@graph_size - 1)
    |> Enum.map(fn n -> KnotHash.hash("#{input}-#{n}") end)
    |> Enum.map(&count_bits/1)
    |> Enum.sum()
  end

  defp count_bits(string) do
    for(<<bit::1 <- string |> String.to_integer(16) |> :binary.encode_unsigned>>, do: bit) |> Enum.sum()
  end

  def part2(input) do
    graph_tuple = 0..(@graph_size - 1)
                  |> Enum.map(fn n -> build_graph_row("#{input}-#{n}") end)
                  |> List.to_tuple()

    0..(@graph_size * @graph_size - 1)
    |> Stream.map(&{div(&1, @graph_size), rem(&1, @graph_size)})
    |> Stream.filter(&(used?(graph_tuple, &1)))
    |> Stream.map(&{ &1, &1 |> find_neighbors(@graph_size) |> Enum.filter(fn n -> used?(graph_tuple, n) end) })
    |> Enum.reduce(:digraph.new, &build_component_graph/2)
    |> :digraph_utils.strong_components()
    |> length
  end

  defp build_component_graph({vertex, neighbors}, graph) do
    :digraph.add_vertex(graph, vertex)
    neighbors |> Enum.reduce(graph, fn(neighbor, acc) ->
      :digraph.add_vertex(acc, neighbor)
      :digraph.add_edge(acc, vertex, neighbor)
      :digraph.add_edge(acc, neighbor, vertex)
      acc
    end)
  end

  defp build_graph_row(string) do
    string
    |> KnotHash.hash()
    |> String.to_integer(16)
    |> Integer.to_string(2)
    |> String.pad_leading(128, "0")
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  defp used?(graph_tuple, {x, y}) do
    #{x, y} |> IO.inspect
    graph_tuple |> elem(y) |> elem(x) |> Kernel.==(1)
  end

  # a = {{1, 0, 0, 0}, {1, 1, 0, 1}, {1, 1, 0, 0}, {1, 1, 1, 0}}
  # only if a[x][y] == 1
  def find_neighbors({x, y}, max) do
    [{x, y-1}, {x-1, y}, {x+1, y}, {x, y+1}]
    |> remove_out_of_bounds(max, [])
  end

  defp remove_out_of_bounds([], _, results), do: Enum.reverse(results)
  defp remove_out_of_bounds([{x, y} | rest], max, results) when x >= 0 and x < max and y >= 0 and y < max do
    remove_out_of_bounds(rest, max, [{x, y} | results])
  end
  defp remove_out_of_bounds([_ | rest], max, results), do: remove_out_of_bounds(rest, max, results)
end
