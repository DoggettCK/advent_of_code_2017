defmodule Day23.DuetProcessor do
  use GenServer

  defstruct registers: %{},
    mul_count: 0,
    instructions: [],
    previous_instructions: []

  def process_instructions(%Day23.DuetProcessor{instructions: [], mul_count: mul_count}), do: mul_count
  def process_instructions(%Day23.DuetProcessor{instructions: [{:set, x, y} | _]} = proc) when is_atom(y), do: process_set(proc, x, Map.get(proc.registers, y, 0))
  def process_instructions(%Day23.DuetProcessor{instructions: [{:set, x, y} | _]} = proc) when is_integer(y), do: process_set(proc, x, y)
  def process_instructions(%Day23.DuetProcessor{instructions: [{:sub, x, y} | _]} = proc) when is_atom(y), do: process_sub(proc, x, Map.get(proc.registers, y, 0))
  def process_instructions(%Day23.DuetProcessor{instructions: [{:sub, x, y} | _]} = proc) when is_integer(y), do: process_sub(proc, x, y)
  def process_instructions(%Day23.DuetProcessor{instructions: [{:mul, x, y} | _]} = proc) when is_atom(y), do: process_mul(proc, x, Map.get(proc.registers, y, 0))
  def process_instructions(%Day23.DuetProcessor{instructions: [{:mul, x, y} | _]} = proc) when is_integer(y), do: process_mul(proc, x, y)
  def process_instructions(%Day23.DuetProcessor{instructions: [{:jnz, x, y} | _]} = proc) when is_integer(x) and is_integer(y), do: process_jnz(proc, x, y)
  def process_instructions(%Day23.DuetProcessor{instructions: [{:jnz, x, y} | _]} = proc) when is_integer(x) and is_atom(y), do: process_jnz(proc, x, Map.get(proc.registers, y, 0))
  def process_instructions(%Day23.DuetProcessor{instructions: [{:jnz, x, y} | _]} = proc) when is_atom(x) and is_integer(y), do: process_jnz(proc, Map.get(proc.registers, x, 0), y)
  def process_instructions(%Day23.DuetProcessor{instructions: [{:jnz, x, y} | _]} = proc) when is_atom(x) and is_atom(y), do: process_jnz(proc, Map.get(proc.registers, x, 0), Map.get(proc.registers, y, 0))

  defp process_set(%Day23.DuetProcessor{} = proc, x, y) do
    [{:set, _, _} = cmd | rest] = proc.instructions

    %Day23.DuetProcessor{proc |
      registers: Map.put(proc.registers, x, y),
      instructions: rest,
      previous_instructions: [cmd | proc.previous_instructions]
    } |> process_instructions()
  end
  defp process_sub(%Day23.DuetProcessor{} = proc, x, y) do
    [{:sub, _, _} = cmd | rest] = proc.instructions

    %Day23.DuetProcessor{proc |
      registers: Map.update(proc.registers, x, y, &(&1 - y)),
      instructions: rest,
      previous_instructions: [cmd | proc.previous_instructions]
    } |> process_instructions()
  end
  defp process_mul(%Day23.DuetProcessor{} = proc, x, y) do
    [{:mul, _, _} = cmd | rest] = proc.instructions

    %Day23.DuetProcessor{proc |
      registers: Map.update(proc.registers, x, 0, &(&1 * y)),
      instructions: rest,
      mul_count: proc.mul_count + 1,
      previous_instructions: [cmd | proc.previous_instructions]
    } |> process_instructions()
  end
  defp process_jnz(%Day23.DuetProcessor{} = proc, x, y) do
    [{:jnz, _, _} = cmd | rest] = proc.instructions

    {new_instructions, new_previous_instructions} = cond do
      x != 0 ->
        pop([cmd | rest], proc.previous_instructions, y)
      true -> {rest, [cmd | proc.previous_instructions]}
    end

    %Day23.DuetProcessor{proc |
      instructions: new_instructions,
      previous_instructions: new_previous_instructions
    } |> process_instructions()
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
