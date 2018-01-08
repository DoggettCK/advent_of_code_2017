defmodule Robot do
  @moduledoc "A robot that can traverse an infinite 2D grid"

  @facings ~w(up right down left)a

  defstruct position: {0, 0}, facing: :up

  def manhattan_distance(%Robot{position: {x, y}}, {from_x, from_y} \\ {0, 0}), do: abs(from_x - x) + abs(from_y - y)
  def neighbors(%Robot{position: {x, y}}) do
    [
      {x - 1, y - 1}, {x, y - 1}, {x + 1, y - 1}, 
      {x - 1, y},                 {x + 1, y}, 
      {x - 1, y + 1}, {x, y + 1}, {x + 1, y + 1}, 
    ]
  end

  def move(%Robot{position: {x, y}, facing: :up} = robot), do: %Robot{robot | position: {x, y - 1}}
  def move(%Robot{position: {x, y}, facing: :down} = robot), do: %Robot{robot | position: {x, y + 1}}
  def move(%Robot{position: {x, y}, facing: :left} = robot), do: %Robot{robot | position: {x - 1, y}}
  def move(%Robot{position: {x, y}, facing: :right} = robot), do: %Robot{robot | position: {x + 1, y}}

  def move_back(%Robot{position: {x, y}, facing: :up} = robot), do: %Robot{robot | position: {x, y + 1}}
  def move_back(%Robot{position: {x, y}, facing: :down} = robot), do: %Robot{robot | position: {x, y - 1}}
  def move_back(%Robot{position: {x, y}, facing: :left} = robot), do: %Robot{robot | position: {x + 1, y}}
  def move_back(%Robot{position: {x, y}, facing: :right} = robot), do: %Robot{robot | position: {x - 1, y}}

  for {facing, right} <- @facings |> Enum.zip(Stream.cycle(@facings) |> Stream.drop(1)) do
    def turn_right(%Robot{facing: unquote(facing)} = robot), do: %Robot{ robot | facing: unquote(right) }
  end

  for {facing, reverse} <- @facings |> Enum.zip(Stream.cycle(@facings) |> Stream.drop(2)) do
    def turn_around(%Robot{facing: unquote(facing)} = robot), do: %Robot{ robot | facing: unquote(reverse) }
  end

  for {facing, left} <- @facings |> Enum.zip(Stream.cycle(@facings) |> Stream.drop(3)) do
    def turn_left(%Robot{facing: unquote(facing)} = robot), do: %Robot{ robot | facing: unquote(left) }
  end
end
