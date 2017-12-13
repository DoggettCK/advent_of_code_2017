defmodule TwistList do
  use Bitwise

  defstruct list: [], current: 0, list_length: 256, skip_size: 0

  def build(list_length \\ 256), do: %TwistList{ list: Enum.to_list(0..(list_length-1)), list_length: list_length }

  def twist_lengths(%TwistList{} = twist_list, lengths) do
    Enum.reduce(lengths, twist_list, fn size, acc -> twist(acc, size) end)
  end

  def twist(%TwistList{ list: list, current: current, list_length: list_length, skip_size: skip_size }, twist_length) do
    new_list = list
               |> Stream.cycle()
               |> Stream.drop(current)
               |> Enum.take(list_length)
               |> do_twist([], twist_length)
               |> Stream.cycle()
               |> Stream.drop(list_length - current)
               |> Enum.take(list_length)

    %TwistList{
      list: new_list,
      current: rem(current + twist_length + skip_size, list_length),
      list_length: list_length,
      skip_size: skip_size + 1
    }
  end

  defp do_twist(list, stack, 0), do: stack ++ list
  defp do_twist([h | t], stack, skip), do: do_twist(t, [h | stack], skip - 1)

  def hash(%TwistList{} = twist_list, lengths) do
    %TwistList{ list: sparse_hash } = do_hash_rounds(twist_list, lengths, 64)

    sparse_hash
    |> Enum.chunk(16)
    |> Enum.map(&calc_dense_hash_element/1)
    |> Enum.join()
    |> String.downcase()
  end

  defp do_hash_rounds(%TwistList{} = twist_list, _lengths, 0), do: twist_list
  defp do_hash_rounds(%TwistList{} = twist_list, lengths, hash_round) do
    do_hash_rounds(TwistList.twist_lengths(twist_list, lengths), lengths, hash_round - 1)
  end

  defp calc_dense_hash_element(list) do
    list
    |> Enum.reduce(0, fn(x, acc) -> acc ^^^ x end)
    |> Integer.to_string(16)
    |> String.pad_leading(2, "0")
  end
end

defmodule Day10 do
  def part1(lengths, list_length \\ 256) do
    list_length
    |> TwistList.build()
    |> TwistList.twist_lengths(lengths)
    |> Map.get(:list)
    |> Enum.take(2)
    |> Enum.reduce(1, &Kernel.*/2)
  end

  @length_padding <<17, 31, 73, 47, 23>>

  def part2(input) do
    TwistList.hash(TwistList.build(), to_charlist(input <> @length_padding))
  end
end
