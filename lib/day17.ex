defmodule SpinLock do
  defstruct buffer: {0}, current: 0

  def insert_next(%SpinLock{ buffer: buffer, current: current } = spin_lock, step_size) do
    buffer_size = tuple_size(buffer)
    next_pos = rem(current + step_size, buffer_size) + 1 

    %SpinLock{ spin_lock |
      buffer: buffer |> Tuple.insert_at(next_pos, buffer_size),
      current: next_pos
    }
  end
end

defmodule Day17 do
  def part1(step_size) do
    %SpinLock{ buffer: buffer, current: current } =
      Enum.reduce(1..2017, %SpinLock{}, fn _, spin_lock ->
        SpinLock.insert_next(spin_lock, step_size)
      end)

    buffer |> elem(current + 1)
  end

  def part2(step_size) do
    # 0 will always be at index 0, so we can skip building the tuple at all,
    # and instead just reduce the sequence, keeping track of when the index
    # to insert after is 0, and updating the answer at those points.
    1..50_000_000
    |> Enum.reduce({0, 0}, fn buffer_size, {current, answer} ->
      case rem(current + step_size + 1, buffer_size) do
        0 -> {0, buffer_size}
        n -> {n, answer}
      end
    end)
    |> elem(1) # Should be left with {current, answer}, just take latter
  end
end
