defmodule KnotHash do
  use Bitwise

  defstruct list: [], current: 0, list_length: 256, skip_size: 0

  def new(list_length \\ 256), do: %KnotHash{ list: Enum.to_list(0..(list_length-1)), list_length: list_length }

  def twist_lengths(%KnotHash{} = knot_hash, lengths) do
    Enum.reduce(lengths, knot_hash, fn size, acc -> twist(acc, size) end)
  end

  def twist(%KnotHash{ list: list, current: current, list_length: list_length, skip_size: skip_size }, twist_length) do
    new_list = list
               |> Stream.cycle()
               |> Stream.drop(current)
               |> Enum.take(list_length)
               |> do_twist([], twist_length)
               |> Stream.cycle()
               |> Stream.drop(list_length - current)
               |> Enum.take(list_length)

    %KnotHash{
      list: new_list,
      current: rem(current + twist_length + skip_size, list_length),
      list_length: list_length,
      skip_size: skip_size + 1
    }
  end

  defp do_twist(list, stack, 0), do: stack ++ list
  defp do_twist([h | t], stack, skip), do: do_twist(t, [h | stack], skip - 1)

  def hash(string) when is_binary(string), do: hash(KnotHash.new, string |> to_charlist)
  def hash(%KnotHash{} = knot_hash, lengths) do
    %KnotHash{ list: sparse_hash } = do_hash_rounds(knot_hash, lengths, 64)

    sparse_hash
    |> Enum.chunk(16)
    |> Enum.map(&calc_dense_hash_element/1)
    |> Enum.join()
    |> String.downcase()
  end

  defp do_hash_rounds(%KnotHash{} = knot_hash, _lengths, 0), do: knot_hash
  defp do_hash_rounds(%KnotHash{} = knot_hash, lengths, hash_round) do
    do_hash_rounds(KnotHash.twist_lengths(knot_hash, lengths), lengths, hash_round - 1)
  end

  defp calc_dense_hash_element(list) do
    list
    |> Enum.reduce(0, fn(x, acc) -> acc ^^^ x end)
    |> Integer.to_string(16)
    |> String.pad_leading(2, "0")
  end
end

