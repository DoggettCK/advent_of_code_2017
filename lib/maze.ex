defmodule Maze do
  defstruct map: %{}, start: nil

  @alphabet ?A..?Z |> Enum.map(&<<&1>>)

  def parse(input) do
    maze = input
           |> String.split("\n", trim: true)
           |> Enum.with_index()
           |> Enum.reduce(%Maze{}, &parse_maze_line/2)
  end

  defp parse_maze_line({line, y}, %Maze{} = maze) do
    line
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.zip(Stream.cycle([y]))
    |> Enum.map(fn {{char, x}, y} -> {char, x, y} end)
    |> Enum.reduce(maze, &build_maze/2)
  end

  defp build_maze({"|", x, 0}, %Maze{map: map} = maze), do: %Maze{ maze | map: Map.put(map, {x, 0}, "|"), start: {x, 0} }
  defp build_maze({char, x, y}, %Maze{map: map} = maze), do: %Maze{ maze | map: Map.put(map, {x, y}, char) }

  def solve(%Maze{map: map, start: {x, 0}}), do: do_solve(map, {x, 0}, {x, -1}, [], 1)

  defp do_solve(map, {x, y} = current, previous, letters, steps) do
    current_char = Map.get(map, current)

    neighbor_coords = cond do
      current_char == "|" -> [{x, y-1}, {x, y+1}]
      current_char == "-" -> [{x-1, y}, {x+1, y}]
      current_char == "+" ->
        cond do
          previous in [{x, y-1}, {x, y+1}] -> [{x-1, y}, {x+1, y}]
          previous in [{x-1, y}, {x+1, y}] -> [{x, y-1}, {x, y+1}]
        end
      current_char in @alphabet -> [{x, y-1}, {x-1, y}, {x+1, y}, {x, y+1}]
      true -> [] # Should never be on a " ", but just in case
    end -- [previous]

    neighbors = neighbor_coords
                |> Enum.map(&{&1, Map.get(map, &1, " ")})
                |> Enum.reject(&reject_blanks/1)

    next_letters = if current_char in @alphabet do
      letters ++ [current_char]
    else 
      letters
    end

    case neighbors do
      [] -> { next_letters |> Enum.join(), steps } # Done traversing, return letters
      [{neighbor, next_char}] ->
        {xn, yn} = neighbor
        case {current_char, next_char} do
          {x, x} -> do_solve(map, neighbor, current, next_letters, steps + 1)
          {"-", "|"} -> do_solve(map, {x + 2 * (xn - x), y}, neighbor, next_letters, steps + 2)
          {"|", "-"} -> do_solve(map, {x, y + 2 * (yn - y)}, neighbor, next_letters, steps + 2)
          _ -> # Can't be blank, must be "+" or letter
            do_solve(map, neighbor, current, next_letters, steps + 1)
        end
    end
  end

  defp reject_blanks({_, " "}), do: true
  defp reject_blanks({_, _}), do: false
end
