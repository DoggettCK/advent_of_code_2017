defmodule Particle do
  @vector_regex ~r{\-?\d+}

  defstruct id: 0,
    position: {0, 0, 0},
    velocity: {0, 0, 0},
    acceleration: {0, 0, 0},
    distance: 0

  def new({line, id}) do
    line
    |> String.trim()
    |> String.split(", ")
    |> Enum.reduce(%Particle{id: id}, &parse_vector/2)
  end

  def update(%Particle{} = particle) do
    new_velocity = add_vector(particle.velocity, particle.acceleration)
    new_position = add_vector(particle.position, new_velocity)

    %Particle{ particle |
      velocity: new_velocity,
      position: new_position,
      distance: manhattan_distance(new_position)
    }
  end

  defp parse_vector("p=" <> vec, %Particle{} = particle) do
    position = do_parse_vector(vec)

    %Particle{ particle | position: position, distance: manhattan_distance(position) }
  end
  defp parse_vector("v=" <> vec, %Particle{} = particle), do: %Particle{ particle | velocity: do_parse_vector(vec) }
  defp parse_vector("a=" <> vec, %Particle{} = particle), do: %Particle{ particle | acceleration: do_parse_vector(vec) }

  defp do_parse_vector(vector_string) when is_binary(vector_string) do
    @vector_regex
    |> Regex.scan(vector_string)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  defp manhattan_distance(vector), do: vector |> Tuple.to_list |> Enum.map(&abs/1) |> Enum.sum
  defp add_vector({a, b, c}, {x, y, z}), do: {a + x, b + y, c + z}
end

defmodule Day20 do
  def part1(input, simulation_count \\ 1000) do
    input
    |> parse
    |> do_simulation(false, simulation_count, %{})
    |> Enum.max_by(fn {_, v} -> v end)
    |> elem(0)
  end

  def part2(input, simulation_count \\ 1000) do
    input
    |> parse
    |> do_simulation(true, simulation_count, %{})
    |> length()
  end


  defp do_simulation(_particles, false, 0, stats), do: stats
  defp do_simulation(particles, true, 0, _stats), do: particles
  defp do_simulation(particles, remove_on_hit, remaining, stats) do
    new_particles = case remove_on_hit do
      false -> particles |> Enum.map(&Particle.update/1)
      true -> particles |> Enum.map(&Particle.update/1) |> remove_collisions()
    end

    closest = Enum.min_by(new_particles, fn %Particle{distance: distance} -> distance end)

    do_simulation(new_particles, remove_on_hit, remaining - 1, Map.update(stats, closest.id, 1, &(&1 + 1)))
  end

  defp remove_collisions(particles) do
    particles
    |> Enum.group_by(fn %Particle{position: position} -> position end)
    |> Enum.reject(fn {_, v} -> length(v) > 1 end)
    |> Enum.map(fn {_, v} -> v end)
    |> List.flatten()
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.map(&Particle.new/1)
  end
end
