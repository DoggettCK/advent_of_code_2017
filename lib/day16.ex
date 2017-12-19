defmodule Day16 do
  @default_programs "abcdefghijklmnop"
  def part1(input, programs \\ @default_programs) do
    input
    |> parse_instructions()
    |> do_rounds(programs, %{}, 1)
  end

  def part2(input, programs \\ @default_programs) do
    input
    |> parse_instructions()
    |> do_rounds(programs, %{}, 1_000_000_000) # TODO: 1_000_000_000
  end

  defp do_rounds(_instructions, programs, _cache, remaining) when remaining <= 0, do: programs
  defp do_rounds(instructions, programs, cache, remaining) do
    [new_remaining, new_programs] = if Map.has_key?(cache, programs) do
      # Have already seen the current state before, so there's obviously a cycle
      # Mod the remaining count by the cache size and subtract 1, and we can skip that many
      new_remaining = rem(remaining, map_size(cache)) - 1
      new_programs = Map.get(cache, programs)

      [new_remaining, new_programs]
    else
      new_programs = instructions
                     |> Enum.reduce(programs |> String.graphemes, &do_instruction/2)
                     |> Enum.join()

      new_remaining = remaining - 1

      [new_remaining, new_programs]
    end

    do_rounds(instructions, new_programs, cache |> Map.put(programs, new_programs), new_remaining)
  end

  defp parse_instructions(instructions) do
    instructions
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&parse_instruction/1) 
  end

  defp do_instruction({:spin, spin_length}, list) do
    spin(list, spin_length)
  end

  defp do_instruction({:exchange, i, j}, list) do
    exchange(list, i, j)
  end

  defp do_instruction({:partner, a, b}, list) do
    partner(list, a, b)
  end

  defp parse_instruction("s" <> spin_length), do: { :spin, String.to_integer(spin_length) }
  defp parse_instruction("x" <> pair) do
    pair |> String.split("/") |> Enum.map(&String.to_integer/1) |> List.to_tuple() |> Tuple.insert_at(0, :exchange)
  end
  defp parse_instruction("p" <> pair) do
    pair |> String.split("/") |> List.to_tuple() |> Tuple.insert_at(0, :partner)
  end

  defp spin(list, spin_length) do
    programs_length = length(list)

    list
    |> Stream.cycle()
    |> Stream.drop(programs_length - spin_length)
    |> Enum.take(programs_length)
  end

  defp exchange(list, i, j) do
    list
    |> List.to_tuple()
    |> tuple_swap(i, j)
    |> Tuple.to_list()
  end

  defp partner(list, a, b) do
    # TODO: Maybe keep a list of current indices in a map
    # If you do this, could just operate on values
    #   spin: values.map(rem(x + shift, 16))
    #   exchange: harder, has to look through all values
    #   partner: take two keys, swap their values
    [i, j] = list
             |> Enum.with_index()
             |> Enum.filter(fn {x, _} -> x in [a, b] end)
             |> Enum.map(&(elem(&1, 1)))

    exchange(list, i, j)
  end

  defp tuple_swap(t, i, j) when is_tuple(t) and i < tuple_size(t) and j < tuple_size(t) and i >= 0 and j >= 0 do
    a = elem(t, i)
    b = elem(t, j)

    t
    |> Tuple.delete_at(i)
    |> Tuple.insert_at(i, b)
    |> Tuple.delete_at(j)
    |> Tuple.insert_at(j, a)
  end
end
