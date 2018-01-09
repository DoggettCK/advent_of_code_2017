defmodule Day23.InstructionParser do
  def parse(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line -> line |> String.trim() |> String.split(" ", trim: true) end)
    |> Enum.map(&parse_instruction/1)
  end


  defp parse_instruction(["set", x, y]), do: parse_2_arg_instruction(:set, x, y)
  defp parse_instruction(["sub", x, y]), do: parse_2_arg_instruction(:sub, x, y)
  defp parse_instruction(["mul", x, y]), do: parse_2_arg_instruction(:mul, x, y)
  defp parse_instruction(["jnz", x, y]), do: parse_2_arg_instruction(:jnz, x, y)

  defp parse_1_arg_instruction(instruction, x), do: {instruction, int_or_atom(x)}
  defp parse_2_arg_instruction(instruction, x, y) do
    {instruction, int_or_atom(x), int_or_atom(y)}
  end

  defp int_or_atom(value) do
    case Integer.parse(value) do
      {i, ""} -> i
      :error -> String.to_atom(value)
    end
  end
end
