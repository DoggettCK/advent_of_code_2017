defmodule TuringMachine do
  defstruct rules: %{},
    tape: %{},
    steps_remaining: 0,
    current_position: 0,
    current_state: nil

  def parse(input) do
    parsed = input
             |> String.trim()
             |> String.split("\n")
             |> Enum.reduce(%{parser_state: :init}, &reduce_instruction/2)
             |> Map.delete(:parser_state)
             |> flush_stored_state()

    struct(TuringMachine, parsed)
    |> Map.put(:rules, Map.drop(parsed, [:steps_remaining, :current_state]))
  end

  def checksum(%TuringMachine{tape: tape}) do
    tape
    |> Map.values()
    |> Enum.count(&(&1 == 1))
  end

  def run(%TuringMachine{steps_remaining: 0} = machine), do: machine
  def run(%TuringMachine{} = machine) do
    current_value = machine.tape |> Map.get(machine.current_position, 0)

    [write_value, move, next_state] = machine.rules |> Map.get({machine.current_state, current_value})

    %TuringMachine{ machine |
      tape: machine.tape |> Map.put(machine.current_position, write_value),
      current_position: case move do
        :left -> machine.current_position - 1
        :right -> machine.current_position + 1
      end,
      current_state: next_state,
      steps_remaining: machine.steps_remaining - 1
    } |> run()
  end

  ### Building state machine from input
  defp reduce_instruction(("Begin in state" <> _) = instruction, %{parser_state: :init} = acc) do
    state = instruction |> match(~r{\ABegin in state (\w+)\.\z})

    acc |> Map.put(:current_state, state)
  end

  defp reduce_instruction(("Perform a diagnostic checksum after" <> _) = instruction, %{parser_state: :init} = acc) do
    steps = instruction
            |> match(~r{\APerform a diagnostic checksum after (\d+) steps\.\z})
            |> String.to_integer()

    acc |> Map.put(:steps_remaining, steps)
  end

  defp reduce_instruction("", %{parser_state: :init} = acc) do
    acc |> Map.put(:parser_state, :state_definition)
  end

  defp reduce_instruction(("In state" <> _) = instruction, acc) do
    state = instruction |> match(~r{\AIn state (\w+):\z})

    acc
    |> Map.put(:defining_state, state)
    |> Map.put(:parser_state, :state_definition)
  end

  defp reduce_instruction("  If the current value is 0:", %{parser_state: :state_definition} = acc) do
    acc |> Map.put(:parser_state, :defining_0)
  end

  defp reduce_instruction("  If the current value is 1:", %{parser_state: :defining_0} = acc) do
    acc |> Map.put(:parser_state, :defining_1)
  end

  defp reduce_instruction("    - Write the value 0.", %{parser_state: :defining_0} = acc) do
    acc |> Map.put(:write_0, 0)
  end

  defp reduce_instruction("    - Write the value 1.", %{parser_state: :defining_0} = acc) do
    acc |> Map.put(:write_0, 1)
  end

  defp reduce_instruction("    - Write the value 0.", %{parser_state: :defining_1} = acc) do
    acc |> Map.put(:write_1, 0)
  end

  defp reduce_instruction("    - Write the value 1.", %{parser_state: :defining_1} = acc) do
    acc |> Map.put(:write_1, 1)
  end

  defp reduce_instruction("    - Move one slot to the left.", %{parser_state: :defining_0} = acc) do
    acc |> Map.put(:move_0, :left)
  end

  defp reduce_instruction("    - Move one slot to the right.", %{parser_state: :defining_0} = acc) do
    acc |> Map.put(:move_0, :right)
  end

  defp reduce_instruction("    - Move one slot to the left.", %{parser_state: :defining_1} = acc) do
    acc |> Map.put(:move_1, :left)
  end

  defp reduce_instruction("    - Move one slot to the right.", %{parser_state: :defining_1} = acc) do
    acc |> Map.put(:move_1, :right)
  end

  defp reduce_instruction("    - Continue with state" <> _ = instruction, %{parser_state: :defining_0} = acc) do
    state = instruction |> match(~r{\A    - Continue with state (\w+)\.\z})

    acc |> Map.put(:next_0, state)
  end

  defp reduce_instruction("    - Continue with state" <> _ = instruction, %{parser_state: :defining_1} = acc) do
    state = instruction |> match(~r{\A    - Continue with state (\w+)\.\z})

    acc |> Map.put(:next_1, state)
  end

  defp reduce_instruction("", %{parser_state: :defining_1} = acc) do
    acc
    |> flush_stored_state()
  end

  defp flush_stored_state(%{} = acc) do
    state = Map.get(acc, :defining_state)

    key_zero = {state, 0}
    zero_keys = ~w(write_0 move_0 next_0)a
    zero_values = zero_keys |> Enum.map(&(Map.get(acc, &1)))

    key_one = {state, 1}
    one_keys = ~w(write_1 move_1 next_1)a
    one_values = one_keys |> Enum.map(&(Map.get(acc, &1)))

    acc
    |> Map.put(key_zero, zero_values)
    |> Map.put(key_one, one_values)
    |> Map.drop(zero_keys ++ one_keys ++ [:defining_state])
  end

  defp match(instruction, regex) do
    regex
    |> Regex.scan(instruction, capture: :all_but_first)
    |> hd()
    |> hd()
  end

end

defmodule Day25 do
  def part1(input) do
    input
    |> TuringMachine.parse()
    |> TuringMachine.run()
    |> TuringMachine.checksum()
  end
end
