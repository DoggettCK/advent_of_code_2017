defmodule Firewall do
  defstruct layers: []

  defmodule Layer do
    defstruct depth: 0, range: 0, stream: nil

    def new(depth, range) do
      %Layer{
        depth: depth,
        range: range,
        stream: build_stream(range)
        # fast-forward to where scanner will be at time(depth)
        # to simplify math when checking delays
      }
    end

    defp build_stream(n) do
      [h | t] = Enum.to_list(0..(n-1))
      [_ | t2] = Enum.reverse(t)

      [h | t] ++ t2
    end

    def position_at(%Layer{stream: stream, depth: depth, range: range}, delay) do
      pos = rem(depth + delay, 2*(range-1))

      Enum.at(stream, pos)
    end
  end

  def new(input) do
    %Firewall{
      layers: input
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&parse_line/1)
    }
  end

  def penalty_at(%Firewall{ layers: layers }, delay) do
    layers
    |> Enum.map(&{&1.depth * &1.range, Layer.position_at(&1, delay) })
    |> Enum.map(fn {score, 0} -> score; _ -> 0 end)
    |> Enum.sum()
  end

  def straight_shot?(%Firewall{ layers: layers }, delay) do
    layers
    |> Enum.map(&(Layer.position_at(&1, delay)))
    |> Enum.all?(fn 0 -> false; _ -> true end)
  end

  defp parse_line(line) do
    [depth, range] = line
                     |> String.trim()
                     |> String.split(": ")
                     |> Enum.map(&String.to_integer/1)

    Firewall.Layer.new(depth, range)
  end
end

defmodule Day13 do
  def part1(input) do
    input
    |> Firewall.new()
    |> Firewall.penalty_at(0)
  end

  def part2(input) do
    firewall = Firewall.new(input)

    1..10_000_000
    |> Stream.map(&{&1, Firewall.straight_shot?(firewall, &1)})
    |> Stream.drop_while(fn {_, open} -> !open end)
    |> Enum.take(1)
    |> hd
    |> elem(0)
  end
end
