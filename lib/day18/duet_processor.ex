defmodule Day18.DuetProcessor do
  use GenServer

  defstruct pid: nil,
    parent: nil,
    partner: nil,
    registers: %{},
    sent: 0,
    instructions: [],
    previous_instructions: []

  def new(parent, id, instructions) do
    spawn_link(__MODULE__, :run, [%Day18.DuetProcessor{registers: %{p: id}, instructions: instructions, parent: parent}])
  end

  def run(%Day18.DuetProcessor{} = proc) do
    # Basically, any time we get a message, update the proc and re-run
    receive do
      {:set_partner, partner} ->
        %Day18.DuetProcessor{proc | partner: partner} |> run()
      {:mail, value} -> 
        [{:rcv, register} | _] = proc.previous_instructions

        %Day18.DuetProcessor{proc |
          registers: Map.put(proc.registers, register, value)
        } |> process_instructions()
      :start ->
        process_instructions(proc)
    after 3_000 ->
      send(proc.parent, {:finished, self(), proc.sent})
    end
  end

  defp process_instructions(%Day18.DuetProcessor{instructions: [{:rcv, x} | rest]} = proc) do
    %Day18.DuetProcessor{proc |
      instructions: rest,
      previous_instructions: [{:rcv, x} | proc.previous_instructions]
    } |> run() # RCV is a special case, go back to loop and wait for message
  end
  defp process_instructions(%Day18.DuetProcessor{instructions: [{:snd, x} | _]} = proc) when is_atom(x), do: process_snd(proc, Map.get(proc.registers, x, 0))
  defp process_instructions(%Day18.DuetProcessor{instructions: [{:snd, x} | _]} = proc) when is_integer(x), do: process_snd(proc, x)
  defp process_instructions(%Day18.DuetProcessor{instructions: [{:set, x, y} | _]} = proc) when is_atom(y), do: process_set(proc, x, Map.get(proc.registers, y, 0))
  defp process_instructions(%Day18.DuetProcessor{instructions: [{:set, x, y} | _]} = proc) when is_integer(y), do: process_set(proc, x, y)
  defp process_instructions(%Day18.DuetProcessor{instructions: [{:add, x, y} | _]} = proc) when is_atom(y), do: process_add(proc, x, Map.get(proc.registers, y, 0))
  defp process_instructions(%Day18.DuetProcessor{instructions: [{:add, x, y} | _]} = proc) when is_integer(y), do: process_add(proc, x, y)
  defp process_instructions(%Day18.DuetProcessor{instructions: [{:mul, x, y} | _]} = proc) when is_atom(y), do: process_mul(proc, x, Map.get(proc.registers, y, 0))
  defp process_instructions(%Day18.DuetProcessor{instructions: [{:mul, x, y} | _]} = proc) when is_integer(y), do: process_mul(proc, x, y)
  defp process_instructions(%Day18.DuetProcessor{instructions: [{:mod, x, y} | _]} = proc) when is_atom(y), do: process_mod(proc, x, Map.get(proc.registers, y, 0))
  defp process_instructions(%Day18.DuetProcessor{instructions: [{:mod, x, y} | _]} = proc) when is_integer(y), do: process_mod(proc, x, y)
  defp process_instructions(%Day18.DuetProcessor{instructions: [{:jgz, x, y} | _]} = proc) when is_integer(x) and is_integer(y), do: process_jgz(proc, x, y)
  defp process_instructions(%Day18.DuetProcessor{instructions: [{:jgz, x, y} | _]} = proc) when is_integer(x) and is_atom(y), do: process_jgz(proc, x, Map.get(proc.registers, y, 0))
  defp process_instructions(%Day18.DuetProcessor{instructions: [{:jgz, x, y} | _]} = proc) when is_atom(x) and is_integer(y), do: process_jgz(proc, Map.get(proc.registers, x, 0), y)
  defp process_instructions(%Day18.DuetProcessor{instructions: [{:jgz, x, y} | _]} = proc) when is_atom(x) and is_atom(y), do: process_jgz(proc, Map.get(proc.registers, x, 0), Map.get(proc.registers, y, 0))

  defp process_snd(%Day18.DuetProcessor{partner: partner} = proc, x) do
    send(partner, {:mail, x})

    [{:snd, _} = cmd | rest] = proc.instructions

    %Day18.DuetProcessor{proc |
      instructions: rest,
      previous_instructions: [cmd | proc.previous_instructions],
      sent: proc.sent + 1
    } |> process_instructions()
  end
  defp process_set(%Day18.DuetProcessor{} = proc, x, y) do
    [{:set, _, _} = cmd | rest] = proc.instructions

    %Day18.DuetProcessor{proc |
      registers: Map.put(proc.registers, x, y),
      instructions: rest,
      previous_instructions: [cmd | proc.previous_instructions]
    } |> process_instructions()
  end
  defp process_add(%Day18.DuetProcessor{} = proc, x, y) do
    [{:add, _, _} = cmd | rest] = proc.instructions

    %Day18.DuetProcessor{proc |
      registers: Map.update(proc.registers, x, y, &(&1 + y)),
      instructions: rest,
      previous_instructions: [cmd | proc.previous_instructions]
    } |> process_instructions()
  end
  defp process_mul(%Day18.DuetProcessor{} = proc, x, y) do
    [{:mul, _, _} = cmd | rest] = proc.instructions

    %Day18.DuetProcessor{proc |
      registers: Map.update(proc.registers, x, 0, &(&1 * y)),
      instructions: rest,
      previous_instructions: [cmd | proc.previous_instructions]
    } |> process_instructions()
  end
  defp process_mod(%Day18.DuetProcessor{} = proc, x, y) do
    [{:mod, _, _} = cmd | rest] = proc.instructions

    %Day18.DuetProcessor{proc |
      registers: Map.update(proc.registers, x, 0, &(rem(&1, y))),
      instructions: rest,
      previous_instructions: [cmd | proc.previous_instructions]
    } |> process_instructions()
  end
  defp process_jgz(%Day18.DuetProcessor{} = proc, x, y) do
    [{:jgz, _, _} = cmd | rest] = proc.instructions

    {new_instructions, new_previous_instructions} = cond do
      x > 0 ->
        pop([cmd | rest], proc.previous_instructions, y)
      true -> {rest, [cmd | proc.previous_instructions]}
    end

    %Day18.DuetProcessor{proc |
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
