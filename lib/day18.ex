defmodule Day18 do
  def part1(input) do
    input
    |> Day18.InstructionParser.parse()
    |> Day18.NaiveProcessor.process_instructions()
  end

  def part2(input) do
    instructions = input |> Day18.InstructionParser.parse()

    caller = self()

    p0 = Day18.DuetProcessor.new(caller, 0, instructions)
    p1 = Day18.DuetProcessor.new(caller, 1, instructions)

    send(p0, {:set_partner, p1})
    send(p1, {:set_partner, p0})

    send(p0, :start)
    send(p1, :start)

    receive do
      {:finished, ^p1, result} -> result 
    end
  end
end

