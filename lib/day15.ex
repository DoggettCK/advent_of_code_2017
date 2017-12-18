defmodule Day15 do
  use Bitwise

  @generator_A_factor 16807
  @generator_B_factor 48271
  @mask 65535

  def part1(a, b, n \\ 40_000_000) do
    { gen_a, gen_b } = generators(a, b)

    gen_a
    |> Stream.zip(gen_b)
    |> Stream.take(n)
    |> Enum.reduce(0, &compare_values/2)
  end

  def part2(a, b, n \\ 5_000_000) do
    { gen_a, gen_b } = generators(a, b)
    gen_a = gen_a |> Stream.filter(&(rem(&1, 4) == 0))
    gen_b = gen_b |> Stream.filter(&(rem(&1, 8) == 0))

    gen_a
    |> Stream.zip(gen_b)
    |> Stream.take(n)
    |> Enum.reduce(0, &compare_values/2)
  end

  defp compare_values({x, y}, acc) do
    case {x &&& @mask, y &&& @mask} do
      {a, a} -> acc + 1
      _ -> acc
    end
  end

  defp generators(a, b) do
    { generator(a, @generator_A_factor), generator(b, @generator_B_factor) }
  end

  defp generator(seed, factor) do
    Stream.resource(
      fn -> seed end,
      fn value -> {[rem(value * factor, 2147483647)], rem(value * factor, 2147483647)} end,
      fn value -> value end
    )
  end


end
