defmodule Prime do
  def is_prime?(n) when n in [2, 3], do: true
  def is_prime?(x) do
    start_lim = div(x, 2)
    Enum.reduce(2..start_lim, {true, start_lim}, fn(fac, {is_prime, upper_limit}) ->
      cond do
        !is_prime -> {false, fac}
        fac > upper_limit -> {is_prime, upper_limit}
        true ->
          is_prime = rem(x, fac) != 0
          upper_limit = if is_prime, do: div(x, fac + 1), else: fac
          {is_prime , upper_limit}
      end
    end) |> elem(0)
  end
end

defmodule Day23 do
  def part1(input) do
    instructions = input |> Day23.InstructionParser.parse()

    %Day23.DuetProcessor{registers: %{}, instructions: instructions}
    |> Day23.DuetProcessor.process_instructions()
  end

  def part2() do
    # Figured out what the code was doing.  Taking every 17th number from b to
    # c, where b = 108100, c = 125100 and rejecting all prime numbers in the
    # range At the end, register 'h' should have the number of non-prime
    # (compound) numbers in the range.
    [from, to, step] = [108100, 125100, 17]

    range(from, to, step)
    |> Enum.reject(&Prime.is_prime?/1)
    |> length
  end

  defp range(s, e, step), do: :lists.seq(s, e + 1, step)
end
