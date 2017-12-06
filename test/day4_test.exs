defmodule Day4Test do
  use ExUnit.Case
  doctest Day4

  test "Day 4, Part 1" do
    assert Day4.valid?("aa bb cc dd ee") == true
    assert Day4.valid?("aa bb cc dd aa") == false
    assert Day4.valid?("aa bb cc dd aaa") == true
    assert Day4.count_valid("test/fixtures/day4_input") == 466
  end

  test "Day 4, Part 2" do
    assert Day4.valid_with_anagrams?("abcde fghij") == true
    assert Day4.valid_with_anagrams?("abcde xyz ecdab") == false
    assert Day4.valid_with_anagrams?("a ab abc abd abf abj") == true
    assert Day4.valid_with_anagrams?("iiii oiii ooii oooi oooo") == true
    assert Day4.valid_with_anagrams?("oiii ioii iioi iiio") == false
    assert Day4.count_valid_with_anagrams("test/fixtures/day4_input") == 251
  end
end

