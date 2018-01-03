defmodule Day18.NaiveProcessor do
  def process_instructions(instructions), do: process_instructions(instructions, [], %{})

  defp process_instructions([], _stack, registers), do: registers
  defp process_instructions([{:snd, x} = cmd | rest], stack, registers) do
    new_value = Map.get(registers, x, 0)
    process_instructions(rest, [cmd | stack], Map.put(registers, :snd, new_value))
  end
  defp process_instructions([{:rcv, x} = cmd | rest], stack, registers) do
    recovered = Map.get(registers, x, 0)

    if recovered != 0 do
      Map.get(registers, :snd)
    else
      process_instructions(rest, [cmd | stack], registers)
    end
  end
  defp process_instructions([{:set, x, y} = cmd | rest], stack, registers) when is_atom(y) do
    new_value = Map.get(registers, y, 0)
    process_instructions(rest, [cmd | stack], Map.put(registers, x, new_value))
  end
  defp process_instructions([{:set, x, y} = cmd | rest], stack, registers) when is_integer(y) do
    process_instructions(rest, [cmd | stack], Map.put(registers, x, y))
  end
  defp process_instructions([{:add, x, y} = cmd | rest], stack, registers) when is_atom(y) do
    new_value = Map.get(registers, y, 0)
    process_instructions(rest, [cmd | stack], Map.update(registers, x, new_value, &(&1 + new_value)))
  end
  defp process_instructions([{:add, x, y} = cmd | rest], stack, registers) when is_integer(y) do
    process_instructions(rest, [cmd | stack], Map.update(registers, x, y, &(&1 + y)))
  end
  defp process_instructions([{:mul, x, y} = cmd | rest], stack, registers) when is_atom(y) do
    new_value = Map.get(registers, y, 0)
    process_instructions(rest, [cmd | stack], Map.update(registers, x, new_value, &(&1 * new_value)))
  end
  defp process_instructions([{:mul, x, y} = cmd | rest], stack, registers) when is_integer(y) do
    process_instructions(rest, [cmd | stack], Map.update(registers, x, 0, &(&1 * y)))
  end
  defp process_instructions([{:mod, x, y} = cmd | rest], stack, registers) when is_atom(y) do
    new_value = Map.get(registers, y, 0)
    process_instructions(rest, [cmd | stack], Map.update(registers, x, new_value, &(rem(&1, new_value))))
  end
  defp process_instructions([{:mod, x, y} = cmd | rest], stack, registers) when is_integer(y) do
    process_instructions(rest, [cmd | stack], Map.update(registers, x, y, &(rem(&1, y))))
  end
  defp process_instructions([{:jgz, x, y} = cmd | rest], stack, registers) when is_atom(y) do
    {new_instructions, new_stack} = cond do
      Map.get(registers, x, 0) > 0 ->
        pop([cmd | rest], stack, Map.get(registers, y, 0))
      true -> {rest, [cmd | stack]}
    end

    process_instructions(new_instructions, new_stack, registers)
  end
  defp process_instructions([{:jgz, x, y} = cmd | rest], stack, registers) when is_integer(y) do
    {new_instructions, new_stack} = cond do
      Map.get(registers, x, 0) > 0 ->
        pop([cmd | rest], stack, y)
      true -> {rest, [cmd | stack]}
    end

    process_instructions(new_instructions, new_stack, registers)
  end

  defp pop(instructions, stack, 0), do: {instructions, stack}
  defp pop(instructions, stack, n) when n > 0 do
    {jumped, remaining} = Enum.split(instructions, n)

    {remaining, jumped |> Enum.reverse() |> Kernel.++(stack)}
  end
  defp pop(instructions, stack, n) when n < 0 do
    {jumped, remaining} = Enum.split(stack, -n)

    {jumped |> Enum.reverse() |> Kernel.++(instructions), remaining}
  end
end
