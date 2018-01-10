defmodule Tree do
  defstruct tree: nil, weights: %{}, weights_with_children: %{}, root: nil

  def new(library) do
    weights = Enum.into(library, %{}, fn {l, w, _} -> {l, w} end)
    tree = library
           |> Enum.into(Keyword.new, fn {l, _, d} -> {l, d} end)
           |> Enum.reduce(:digraph.new, &add_vertex_and_children/2)

    %Tree{
      tree: tree,
      weights: weights,
      root: tree |> :digraph_utils.postorder() |> hd
    } |> build_subtree_weights()
  end

  ### Building the tree
  defp add_vertex_and_children({vertex, children}, tree) do
    :digraph.add_vertex(tree, vertex) # noop if vert already added
    add_children(tree, vertex, children)
  end

  defp add_children(tree, _vert, []), do: tree
  defp add_children(tree, vert, [vert | rest]), do: add_children(tree, vert, rest)
  defp add_children(tree, vert, [child | rest]) do
    :digraph.add_vertex(tree, child) # noop if child already added
    :digraph.add_edge(tree, child, vert) # children represented as an edge d -> v
    add_children(tree, vert, rest)
  end

  ### Helper methods
  def print(%Tree{} = tree) do
    do_print(tree, tree.root, 0)
  end

  defp do_print(%Tree{weights: weights} = tree, vert, level) do
    indent = String.duplicate("  ", level)

    IO.puts "#{indent}#{vert} (#{Map.get(weights, vert)}) (#{Map.get(tree.weights_with_children, vert)})"

    tree
    |> children(vert)
    |> Enum.each(&(do_print(tree, &1, level + 1)))
  end

  def find_uneven_node(%Tree{tree: graph} = tree) do
    #map verts to find all whose children have same weight, but aren't the same weight as any siblings
    {_, _, _, siblings, _} = graph
                             |> :digraph.vertices()
                             |> Enum.map(&{&1, children(tree, &1), siblings(tree, &1)})
                             |> Enum.map(fn {vert, kids, sibs} ->
                               {
                                 vert,
                                 Enum.map(kids, fn v -> {v, Map.get(tree.weights_with_children, v)} end),
                                 Enum.map(sibs, fn v -> {v, Map.get(tree.weights_with_children, v)} end)
                               }
                             end)
                             |> Enum.reject(fn {_, [], _} -> true; {_, _, []} -> true; _ -> false end)
                             |> Enum.map(fn {vert, kids, sibs} ->
                               {
                                 vert,
                                 kids,
                                 kids |> Enum.group_by(fn {_, w} -> w end) |> Map.size(),
                                 sibs,
                                 sibs |> Enum.group_by(fn {_, w} -> w end) |> Map.size()
                               }
                             end)
                             |> Enum.reject(fn {_, _, 1, _, 1} -> true; _ -> false end)
                             |> Enum.sort_by(fn {v, _, _, _, _} -> Map.get(tree.weights_with_children, v) end)
                             |> hd()

    weight_groups = siblings |> Enum.group_by(fn {_, v} -> v end)

    {odd_weight, odd_node} = Enum.filter(weight_groups, fn {_, v} -> length(v) == 1 end) |> hd()
    {balanced_weight, _} = Enum.filter(weight_groups, fn {_, v} -> length(v) > 1 end) |> hd()

    correction = balanced_weight - odd_weight
    odd_vert = odd_node |> hd() |> elem(0)
    incorrect_weight = Map.get(tree.weights, odd_vert)

    {odd_vert, incorrect_weight, correction, incorrect_weight + correction, balanced_weight}
  end

  ### Subtree stuff
  def parent(%Tree{root: root}, root), do: root
  def parent(%Tree{tree: tree}, vert) do
    tree
    |> :digraph.out_neighbours(vert)
    |> hd()
  end

  def children(%Tree{tree: tree}, vert) do
    :digraph.in_neighbours(tree, vert)
  end

  def siblings(%Tree{root: root}, root), do: []
  def siblings(%Tree{} = tree, vert) do
    tree
    |> children(tree |> parent(vert))
  end

  defp build_subtree_weights(%Tree{} = tree) do
    %Tree{ tree |
      weights_with_children: :digraph.vertices(tree.tree)
      |> Enum.map(&{&1, do_subtree_weight(tree, &1)})
      |> Enum.into(%{})
    }
  end
  defp do_subtree_weight(%Tree{} = tree, vert) do
    do_subtree_weight(tree, vert, children(tree, vert))
  end
  defp do_subtree_weight(%Tree{weights: weights}, vert, []), do: Map.get(weights, vert)
  defp do_subtree_weight(%Tree{} = tree, vert, children) do
    children
    |> Enum.map(&(do_subtree_weight(tree, &1, children(tree, &1))))
    |> Enum.sum()
    |> Kernel.+(Map.get(tree.weights, vert))
  end
end

