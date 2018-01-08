defmodule Day3 do
  def part1(number) do
    process_part1(%{bounds: {0, 0, 0, 0}, last: 0}, %Robot{facing: :right}, number)
    |> Robot.manhattan_distance()
  end

  defp process_part1(%{last: until}, %Robot{} = robot, until) do
    robot
    |> Robot.move_back()
  end
  defp process_part1(%{bounds: {min_x, min_y, max_x, max_y}} = board, %Robot{facing: :right, position: {x, _}} = robot, until) when x == (max_x + 1) do
    turn_and_process_part1(board, robot, until, {min_x, min_y, x, max_y})
  end
  defp process_part1(%{bounds: {min_x, min_y, max_x, max_y}} = board, %Robot{facing: :up, position: {_, y}} = robot, until) when y == (min_y - 1) do
    turn_and_process_part1(board, robot, until, {min_x, y, max_x, max_y})
  end
  defp process_part1(%{bounds: {min_x, min_y, max_x, max_y}} = board, %Robot{facing: :left, position: {x, _}} = robot, until) when x == (min_x - 1) do
    turn_and_process_part1(board, robot, until, {x, min_y, max_x, max_y})
  end
  defp process_part1(%{bounds: {min_x, min_y, max_x, max_y}} = board, %Robot{facing: :down, position: {_, y}} = robot, until) when y == (max_y + 1) do
    turn_and_process_part1(board, robot, until, {min_x, min_y, max_x, y})
  end
  defp process_part1(%{last: last} = board, %Robot{position: position} = robot, until) do
    new_board = board
                |> Map.put(:last, last + 1)
                |> Map.put(position, last + 1)

    new_robot = robot
                |> Robot.move()

    process_part1(new_board, new_robot, until)

  end

  defp turn_and_process_part1(%{last: last} = board, %Robot{position: position} = robot, until, new_bounds) do
    new_board = board
                |> Map.put(:last, last + 1)
                |> Map.put(:bounds, new_bounds)
                |> Map.put(position, last + 1)

    new_robot = robot
                |> Robot.turn_left()
                |> Robot.move()

    process_part1(new_board, new_robot, until)
  end

  def part2(number) do
    process_part2(%{:bounds => {0, 0, 0, 0}, :last => 1, {0, 0} => 1}, %Robot{facing: :right, position: {1, 0}}, number)
  end

  defp process_part2(%{last: last} = board, %Robot{} = robot, until) when last > until, do: last
  defp process_part2(%{bounds: {min_x, min_y, max_x, max_y}} = board, %Robot{facing: :right, position: {x, _}} = robot, until) when x == (max_x + 1) do
    turn_and_process_part2(board, robot, until, {min_x, min_y, x, max_y})
  end
  defp process_part2(%{bounds: {min_x, min_y, max_x, max_y}} = board, %Robot{facing: :up, position: {_, y}} = robot, until) when y == (min_y - 1) do
    turn_and_process_part2(board, robot, until, {min_x, y, max_x, max_y})
  end
  defp process_part2(%{bounds: {min_x, min_y, max_x, max_y}} = board, %Robot{facing: :left, position: {x, _}} = robot, until) when x == (min_x - 1) do
    turn_and_process_part2(board, robot, until, {x, min_y, max_x, max_y})
  end
  defp process_part2(%{bounds: {min_x, min_y, max_x, max_y}} = board, %Robot{facing: :down, position: {_, y}} = robot, until) when y == (max_y + 1) do
    turn_and_process_part2(board, robot, until, {min_x, min_y, max_x, y})
  end
  defp process_part2(%{last: last} = board, %Robot{position: position} = robot, until) do
    neighbor_sum = robot
                   |> Robot.neighbors()
                   |> Enum.map(fn neighbor -> Map.get(board, neighbor) end)
                   |> Enum.reject(&is_nil/1)
                   |> Enum.sum()

    new_board = board
                |> Map.put(:last, neighbor_sum)
                |> Map.put(position, neighbor_sum)

    new_robot = robot
                |> Robot.move()

    process_part2(new_board, new_robot, until)

  end

  defp turn_and_process_part2(%{last: last} = board, %Robot{position: position} = robot, until, new_bounds) do
    neighbor_sum = robot
                   |> Robot.neighbors()
                   |> Enum.map(fn neighbor -> Map.get(board, neighbor) end)
                   |> Enum.reject(&is_nil/1)
                   |> Enum.sum()

    new_board = board
                |> Map.put(:last, neighbor_sum)
                |> Map.put(:bounds, new_bounds)
                |> Map.put(position, neighbor_sum)

    new_robot = robot
                |> Robot.turn_left()
                |> Robot.move()

    process_part2(new_board, new_robot, until)
  end
end

