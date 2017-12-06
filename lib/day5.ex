defmodule Day5 do
  def read_lines(filename) do
    filename
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end

  def part1(instructions), do: do_part1(instructions, [], 0)

  defp do_part1([], _stack, steps), do: steps
  defp do_part1([jump | offsets], stack, steps) do
    [new_offsets, new_stack] = handle_instructions_part1([jump + 1 | offsets], stack, jump)
    do_part1(new_offsets, new_stack, steps + 1)
  end

  defp handle_instructions_part1([], stack, _jump), do: [[], stack]
  defp handle_instructions_part1([h | t], stack, jump) when jump > 0, do: handle_instructions_part1(t, [h | stack], jump - 1)
  defp handle_instructions_part1(offsets, [h | t], jump) when jump < 0, do: handle_instructions_part1([h | offsets], t, jump + 1)
  defp handle_instructions_part1(offsets, stack, 0), do: [offsets, stack]

  def part2(instructions), do: do_part2(instructions, [], 0)

  defp do_part2([], _stack, steps), do: steps
  defp do_part2([jump | offsets], stack, steps) when jump >= 3 do
    [new_offsets, new_stack] = handle_instructions_part2([jump - 1 | offsets], stack, jump)
    do_part2(new_offsets, new_stack, steps + 1)
  end
  defp do_part2([jump | offsets], stack, steps) do
    [new_offsets, new_stack] = handle_instructions_part2([jump + 1 | offsets], stack, jump)
    do_part2(new_offsets, new_stack, steps + 1)
  end

  defp handle_instructions_part2([], stack, _jump), do: [[], stack]
  defp handle_instructions_part2([h | t], stack, jump) when jump > 0, do: handle_instructions_part2(t, [h | stack], jump - 1)
  defp handle_instructions_part2(offsets, [h | t], jump) when jump < 0, do: handle_instructions_part2([h | offsets], t, jump + 1)
  defp handle_instructions_part2(offsets, stack, 0), do: [offsets, stack]
end
