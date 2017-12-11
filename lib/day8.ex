defmodule Day8 do
  @highest_key :highest_seen

  def part1(file_contents) do
    file_contents 
    |> parse()
    |> Map.delete(@highest_key)
    |> Enum.max_by(fn {_, v} -> v end)
    |> elem(1)
  end

  def part2(file_contents) do
    file_contents 
    |> parse()
    |> Map.get(@highest_key, 0)
  end

  def parse(file_contents) do
    file_contents
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.reduce(%{}, &parse_line/2)
  end

  def parse_line(line, state) do
    [instruction, conditional] = line |> String.split(" if ")

    if conditional_applies?(state, conditional) do
      perform_operation(state, instruction)
    else
      state
    end
  end

  defp perform_operation(state, instruction) do
    [key, operation, value_string] = String.split(instruction, " ")

    increment_value = do_increment(operation, String.to_integer(value_string))

    new_value = Map.get(state, String.to_atom(key), 0) + increment_value
    previous_max = Map.get(state, @highest_key, 0)

    state
    |> Map.put(String.to_atom(key), new_value)
    |> Map.put(@highest_key, Enum.max([previous_max, new_value]))
  end

  defp do_increment(_, 0), do: 0
  defp do_increment("dec", n), do: -n
  defp do_increment(_, n), do: n

  defp conditional_applies?(state, conditional) do
    [key, operation, value_string] = String.split(conditional, " ")

    current_value = Map.get(state, String.to_atom(key), 0)
    check_value = String.to_integer(value_string)

    apply(Kernel, String.to_atom(operation), [current_value, check_value])
  end
end
