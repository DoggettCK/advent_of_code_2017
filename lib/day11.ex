defmodule Day11 do
  defstruct x: 0, y: 0, max_distance: 0, current_distance: 0

  def part1(input) do
    input
    |> String.trim()
    |> String.split(",")
    |> Enum.reduce(new({0, 0}), &transform/2)
    |> Map.get(:current_distance)
  end

  def part2(input) do
    input
    |> String.trim()
    |> String.split(",")
    |> Enum.reduce(new({0, 0}), &transform/2)
    |> Map.get(:max_distance)
  end

  defp new({ x, y }), do: %Day11{ x: x, y: y } |> update_distances()

  defp transform("n", %Day11{x: x, y: y} = d), do: %Day11{d | x: x, y: y+1} |> update_distances()
  defp transform("s", %Day11{x: x, y: y} = d), do: %Day11{d | x: x, y: y-1} |> update_distances()
  defp transform("ne", %Day11{x: x, y: y} = d), do: %Day11{d | x: x+1, y: y} |> update_distances()
  defp transform("nw", %Day11{x: x, y: y} = d), do: %Day11{d | x: x-1, y: y+1} |> update_distances()
  defp transform("se", %Day11{x: x, y: y} = d), do: %Day11{d | x: x+1, y: y-1} |> update_distances()
  defp transform("sw", %Day11{x: x, y: y} = d), do: %Day11{d | x: x-1, y: y} |> update_distances()
  defp transform(_, %Day11{x: x, y: y} = d), do: %Day11{d | x: x, y: y} |> update_distances()

  defp update_distances(%Day11{x: x, y: y, max_distance: max_distance}) do
    current_distance = hex_distance({x, y})

    %Day11{
      x: x,
      y: y,
      current_distance: current_distance,
      max_distance: Enum.max([max_distance, current_distance])
    }
  end

  defp axial_to_cube({q, r}), do: {q, -q-r, r}
  defp hex_distance(a, b \\ {0, 0}) do
    cube_distance(axial_to_cube(a), axial_to_cube(b))
  end

  defp cube_distance({ax, ay, az}, {bx, by, bz}) do
    Enum.max([abs(ax-bx), abs(ay-by), abs(az-bz)])
  end
end
