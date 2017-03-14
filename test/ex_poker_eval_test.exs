defmodule ExPokerEvalTest do
  use ExUnit.Case
  doctest ExPokerEval

  import ExPokerEval

  describe "get_highest" do
    test "return error when invalid duplicated cards are detected" do
      hands = [
        black: ~w(2H 2H 5S 9C KD),
        white: ~w(2C 3H 4S 8C AH)
      ]

      assert get_highest(hands) == {:error, :repeated_card}
    end

    test "return error when any hand has invalid size" do
      hands = [
        black: ~w(2H 3H 5S 9C KD),
        white: ~w()
      ]

      assert get_highest(hands) == {:error, :invalid_hand_size}
    end

    test "parses the two hands" do
      hands = [
        black: ~w(3H 3D 3S 9C KD),
        white: ~w(2C 3H 4S 8C AH)
      ]

      assert get_highest(hands) == {:black, :three_of_a_kind, 3}
    end

    test "uses value for equal ranks" do
      hands = [
        black: ~w(2H 2C 2S JH JC),
        white: ~w(2H 2C 2S 5S 5C)
      ]

      assert get_highest(hands) == {:black, :full_house, 11}
    end

    test "recursively finds the next rank" do
      hands = [
        black: ~w(2H 2C 2S 5H 8C),
        white: ~w(2H 2C 2S 3S AC)
      ]

      assert get_highest(hands) == {:white, :high_card, 14}
    end
  end

  describe "compare" do
    test "finds the highest rank of two sets of cards with different first highest rank" do
      b = [
        [suit: "H", value: 2],
        [suit: "D", value: 3],
        [suit: "S", value: 5],
        [suit: "C", value: 9],
        [suit: "D", value: 13]
      ]

      w = [
        [suit: "C", value: 2],
        [suit: "H", value: 3],
        [suit: "S", value: 4],
        [suit: "C", value: 14],
        [suit: "H", value: 14]
      ]

      assert compare(b, w) == {:white, :pair, 14}
    end
  end
end
