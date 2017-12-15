defmodule Tree do
  defstruct tree: :digraph.new, weights: %{}, root: nil

  def new(library) do
    weights = Enum.into(library, %{}, fn {l, w, _} -> {l, w} end)
    tree = library
            |> Enum.into(Keyword.new, fn {l, _, d} -> {l, d} end)
            |> Enum.reduce(:digraph.new, &add_vertex_and_children/2)

    %Tree{ tree: tree, weights: weights, root: tree |> :digraph_utils.postorder() |> hd }
  end

  def find_unbalanced_subtree(%Tree{tree: tree, weights: weights, root: root}) do
    kid_weights = tree
                  |> children(root)
                  |> Enum.map(fn v -> {v, total_weight(weights, [v]), total_weight(weights, [v] ++ children(tree, v))} end)
                  |> Enum.group_by(fn {_, _, w} -> w end)

    {_vert, weight, weight_with_kids} = kid_weights |> Enum.filter(fn {_, [_]} -> true; _ -> false end) |> Enum.map(fn {_, vert} -> vert end) |> hd |> hd
    ideal_weight = kid_weights |> Enum.filter(fn {_, [_]} -> false; _ -> true end) |> Enum.map(fn {weight, _} -> weight end) |> hd

    if weight_with_kids > ideal_weight do
      weight - (weight_with_kids - ideal_weight)
    else
      weight - (ideal_weight - weight_with_kids)
    end
  end

  def total_weight(weights, verts) do
    verts |> Enum.map(&(Map.get(weights, &1, 0))) |> Enum.sum
  end

  def subtree(tree, vert) do
    do_subtree(tree, children(tree, vert), [vert])
  end

  defp do_subtree(_tree, [], results), do: results
  defp do_subtree(tree, [h | t], results) do
    do_subtree(tree, t, [h | do_subtree(tree, children(tree, h), results)])
  end

  defp children(tree, vert) do
    :digraph.in_neighbours(tree, vert)
  end

  # Building the tree
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
end

