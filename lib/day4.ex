defmodule Day4 do
  def count_valid(filename) do
    filename
    |> read_lines()
    |> Enum.map(&valid?/1)
    |> Enum.count(&(&1))
  end

  def count_valid_with_anagrams(filename) do
    filename
    |> read_lines()
    |> Enum.map(&valid_with_anagrams?/1)
    |> Enum.count(&(&1))
  end

  def valid?(passphrase) do
    passphrase
    |> String.trim()
    |> String.split(~r{\s+})
    |> Enum.reduce(%{}, &update_dict/2)
    |> Enum.all?(fn {_, v} -> v == 1 end)
  end

  def valid_with_anagrams?(passphrase) do
    passphrase
    |> String.trim()
    |> String.split(~r{\s+})
    |> Enum.map(&checksum/1)
    |> Enum.reduce(%{}, &update_dict/2)
    |> Enum.all?(fn {_, v} -> v == 1 end)
  end

  defp update_dict(word, dict) do
    dict |> Map.update(word, 1, &(&1 + 1))
  end

  defp checksum(word) do
    word
    |> String.graphemes()
    |> Enum.sort()
    |> Enum.join()
  end

  defp read_lines(filename) do
    filename
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
  end
end
