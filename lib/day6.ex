defmodule Day6 do
  def part1(banks) do
    banks
    |> build_stream()
    |> Enum.reduce_while(%{}, &have_not_seen?/2)
    |> Map.get(:count)
  end

  def part2(banks) do
    { found_cycle, 2 } = banks
    |> build_stream()
    |> Enum.reduce_while(%{}, &have_not_seen?/2)
    |> Enum.find(fn {k, v} -> k != :count && v == 2 end)
    
    part1(found_cycle) - 1
  end

  defp have_not_seen?(current, dict) do
    if Map.has_key?(dict, current) do
      {:halt, Map.update(dict, current, 1, &(&1 + 1)) |> update_count()}
    else
      {:cont, Map.put(dict, current, 1) |> update_count()}
    end
  end

  defp update_count(dict) do
    Map.update(dict, :count, 1, &(&1 + 1))
  end
  defp build_stream(banks) do
    Stream.resource(fn -> banks end, &update_banks/1, &(&1))
  end

  defp update_banks(banks) do
    # just update to the next state, Stream reader will handle checking for if it's been seen
    max = Enum.max(banks)

    { head, tail } = split_banks_by_max(banks, max)

    next_state = redistribute_wealth(tail, Enum.reverse(head), max)

    {[next_state], next_state}
  end

  defp redistribute_wealth([], stack, 0), do: Enum.reverse(stack)
  defp redistribute_wealth([h | t], stack, 0), do: redistribute_wealth(t, [h | stack], 0)
  defp redistribute_wealth([], stack, remaining), do: redistribute_wealth(Enum.reverse(stack), [], remaining)
  defp redistribute_wealth([h | t], stack, remaining), do: redistribute_wealth(t, [h + 1 | stack], remaining - 1)

  defp split_banks_by_max([max | rest], max), do: { [0], rest }
  defp split_banks_by_max(banks, max) do
    # guaranteed max is in the list
    case Enum.chunk_by(banks, &(&1 == max)) do
      [head, [^max] | tail] -> { head ++ [0], List.flatten(tail) }
      [head, [^max | rest] | tail] -> { head ++ [0], List.flatten(rest ++ tail) }
    end
  end
end
