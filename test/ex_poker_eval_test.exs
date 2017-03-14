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
        black: ~w(2H 3D 5S 9C KD),
        white: ~w(2C 3H 4S 8C AH)
      ]

      assert get_highest(hands) == [
        black: [
          [suit: "H", value: 2],
          [suit: "D", value: 3],
          [suit: "S", value: 5],
          [suit: "C", value: 9],
          [suit: "D", value: 13]
        ],
        white: [
          [suit: "C", value: 2],
          [suit: "H", value: 3],
          [suit: "S", value: 4],
          [suit: "C", value: 8],
          [suit: "H", value: 14]
        ]
      ]
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
