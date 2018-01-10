defmodule Dominoes do
  def chains(dominoes) do
    dominoes
    |> permutations()
    |> Enum.reduce([], &reduce_permutation/2)
    |> List.flatten()
  end

  defp reduce_permutation([head | tail], results) do
    [chain(tail, [], head, nil) | results]
  end

  # Nothing left to process, ends match, full chain
  defp chain([], [{a, _} | _] = acc, {_, a} = candidate, _) do
    [{:full, acc ++ [candidate]}]
  end

  # Nothing left to process, ends don't match, partial chain
  defp chain([], [_, _ | _] = partial, {a, _} = candidate, {_, a}) do
    [{:partial, partial ++ [candidate]}]
  end

  # Nothing left to process, ends don't match, partial chain
  defp chain([], [_, _ | _] = partial, {_, a} = candidate, {_, a}) do
    [{:partial, partial ++ [candidate]}]
  end

  # Nothing left to process, ends don't match, last candidate can't be added
  defp chain([], [_, _ | _] = partial, _, _) do
    [{:partial, partial}]
  end

  # Next to check has both ends matching the candidate, so add it
  defp chain([{a, a} = head | tail], acc, {_, a} = candidate, _) do
    chain(tail, acc ++ [candidate], head, candidate)
  end

  # Next to check matches on front only, add as-is
  defp chain([{a, _} = head | tail], acc, {_, a} = candidate, _) do
    chain(tail, acc ++ [candidate], head, candidate)
  end

  # Next to check matches on front only, add flipped
  defp chain([{b, a} | tail], acc, {_, a} = candidate, _) do
    chain(tail, acc ++ [candidate], {a, b}, candidate)
  end

  # Nothing further could be made, but chain has at least two items, so return partial
  defp chain(_, [_, _ | _] = list, _, _) do
    [{:partial, list}]
  end

  # Single-item chain was the best we could do
  defp chain(_, _, _, _) do
    [{:impossible, []}]
  end

  defp permutations([]), do: [[]]
  defp permutations(list) do
    for head <- list,
      tail <- permutations(list -- [head]) do
        [head | tail]
      end
  end
end

