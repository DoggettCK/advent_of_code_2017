defmodule Day1 do

  def part1(str) do
    str
    |> String.last()
    |> Kernel.<>(str)
    |> do_part_1_captcha(0)
  end

  defp do_part_1_captcha("", result), do: result
  defp do_part_1_captcha(<<_::binary-size(1)>>, result), do: result
  defp do_part_1_captcha(<<a::binary-size(1), a::binary-size(1), rest::binary>>, result) do
    do_part_1_captcha(a <> rest, a |> String.to_integer() |> Kernel.+(result))
  end
  defp do_part_1_captcha(<<_::binary-size(1), b::binary-size(1), rest::binary>>, result) do
    do_part_1_captcha(b <> rest, result)
  end

  def part2(str) do
    l = String.length(str)
    hl = div(l, 2)

    graphemes = str |> String.graphemes()
    wrapped = graphemes |> Stream.cycle() |> Stream.drop(hl) |> Enum.take(l)
    do_part_2_captcha(graphemes, wrapped, 0)
  end

  defp do_part_2_captcha([], [], result), do: result
  defp do_part_2_captcha([h|t1], [h|t2], result) do
    do_part_2_captcha(t1, t2, h |> String.to_integer() |> Kernel.+(result))
  end
  defp do_part_2_captcha([_h|t1], [_h2|t2], result) do
    do_part_2_captcha(t1, t2, result)
  end
end
