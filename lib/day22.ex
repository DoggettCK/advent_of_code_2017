defmodule Day22 do
  defstruct cells: %{},
    virus: %Robot{},
    infected: 0,
    cleaned: 0,
    weakened: 0,
    flagged: 0

  def part1(input, bursts) do
    input
    |> parse_board()
    |> do_part1(bursts)
  end

  def part2(input, bursts) do
    input
    |> parse_board()
    |> do_part2(bursts)
  end

  defp parse_board(input) do

    lines = input
            |> String.trim()
            |> String.split("\n")

    shift_size = lines
                 |> length()
                 |> div(2)

    cells = lines
            |> Enum.with_index()
            |> Enum.reduce([], &parse_board_row/2)
            |> Enum.map(fn {x, y} -> {x - shift_size, y - shift_size} end)
            |> Enum.into(%{}, fn k -> {k, "I"} end)

    %Day22{cells: cells}
  end

  defp parse_board_row({row, y}, cells) do
    row
    |> String.trim()
    |> String.split("", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(cells, fn
      {"#", x}, acc -> [{x, y} | acc]
      _, acc -> acc
    end)
  end

  defp do_part1(%Day22{infected: infected}, 0), do: infected
  defp do_part1(%Day22{cells: cells, virus: virus} = board, remaining) do
    new_board = case Map.get(cells, virus.position, "C") do
      "I" ->
        # Turn right, clean, move forward
        %Day22{board |
          cells: cells |> Map.put(virus.position, "C"),
          cleaned: board.cleaned + 1,
          virus: virus |> Robot.turn_right() |> Robot.move()
        }
      _ ->
        # Turn left, infect, move forward
        %Day22{board |
          cells: cells |> Map.put(virus.position, "I"),
          infected: board.infected + 1,
          virus: virus |> Robot.turn_left() |> Robot.move()
        }
    end

    do_part1(new_board, remaining - 1)
  end

  defp do_part2(%Day22{infected: infected}, 0), do: infected
  defp do_part2(%Day22{cells: cells, virus: virus} = board, remaining) do
    new_board = case Map.get(cells, virus.position, "C") do
      "C" ->
        # Turn left, weaken, move forward
        %Day22{board |
          cells: cells |> Map.put(virus.position, "W"),
          weakened: board.weakened + 1,
          virus: virus |> Robot.turn_left() |> Robot.move()
        }
      "W" ->
        # Infect, move forward
        %Day22{board |
          cells: cells |> Map.put(virus.position, "I"),
          infected: board.infected + 1,
          virus: virus |> Robot.move()
        }
      "I" ->
        # Turn right, flag, move forward
        %Day22{board |
          cells: cells |> Map.put(virus.position, "F"),
          flagged: board.flagged + 1,
          virus: virus |> Robot.turn_right() |> Robot.move()
        }
      "F" ->
        # Turn around, clean, move forward
        %Day22{board |
          cells: cells |> Map.put(virus.position, "C"),
          cleaned: board.cleaned + 1,
          virus: virus |> Robot.turn_around() |> Robot.move()
        }
    end

    do_part2(new_board, remaining - 1)
  end
end
