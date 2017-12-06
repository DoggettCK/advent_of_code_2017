defmodule Day3 do
  @squares 1..1000
  |> Enum.take_every(2)
  |> Enum.map(&{&1, &1 * &1})
  |> Enum.map(fn {n, ns} -> {n, [ns-3*(n-1), ns-2*(n-1), ns-(n-1), ns]} end)

  def part1(1), do: 0
  def part1(number) do
    [{width, square}] =
      @squares
      |> Enum.drop_while(fn {_, [_, _, _, odd_square]} -> odd_square < number end)
      |> Enum.take(1)

    if number in square do
      width - 1
    else
      find_on_edge(number, width, square)
    end
  end

  # max will never equal corner, as we caught that case above
  defp find_on_edge(number, width, [max | corners]) when max < number, do: find_on_edge(number, width, corners)
  defp find_on_edge(number, width, [max | _]) do
    # since we're on an edge, one horizontal/vertical component will always be div(width, 2)
    known_component = div(width, 2)
    center_of_edge = div(2*max - width + 1, 2)

    if center_of_edge == number do
      known_component
    else
      known_component + abs(center_of_edge - number)
    end
  end
end

