defmodule ExPokerEval.RankTest do
  use ExUnit.Case
  doctest ExPokerEval.Rank

  alias ExPokerEval.Rank

  @highcard_cards [
    [suit: "H", value: 2],
    [suit: "D", value: 3],
    [suit: "S", value: 5],
    [suit: "C", value: 9],
    [suit: "D", value: 13]
  ]

  @straight_lower_cards [
    [suit: "H", value: 14],
    [suit: "D", value: 2],
    [suit: "S", value: 3],
    [suit: "C", value: 4],
    [suit: "D", value: 5]
  ]

  @straight_middle_cards [
    [suit: "D", value: 2],
    [suit: "S", value: 3],
    [suit: "C", value: 4],
    [suit: "D", value: 5],
    [suit: "H", value: 6]
  ]

  @straight_upper_cards [
    [suit: "D", value: 10],
    [suit: "S", value: 11],
    [suit: "C", value: 12],
    [suit: "D", value: 13],
    [suit: "H", value: 14]
  ]

  describe "get_straight" do
    test "return empty tuple if not found" do
      assert Rank.get_straight(@highcard_cards) == {}
    end

    test "get a straight whithout ace" do
      assert Rank.get_straight(@straight_middle_cards) == {:straight, 6}
    end

    test "get upper straight" do
      assert Rank.get_straight(@straight_upper_cards) == {:straight, 14}
    end

    test "get lower straight" do
      assert Rank.get_straight(@straight_lower_cards) == {:straight, 5}
    end
  end

  describe "get_flush" do
    test "returns empty if not found" do
      hand = [
        [suit: "D", value: 2],
        [suit: "D", value: 3],
        [suit: "C", value: 4],
        [suit: "D", value: 5],
        [suit: "D", value: 6]
      ]

      assert Rank.get_flush(hand) == {}
    end

    test "detects the flush and the higest value" do
      hand = [
        [suit: "D", value: 2],
        [suit: "D", value: 3],
        [suit: "D", value: 4],
        [suit: "D", value: 5],
        [suit: "D", value: 12]
      ]

      assert Rank.get_flush(hand) == {:flush, 12}
    end
  end

  describe "get_pair" do
    test "return empty if not found" do
      hand = [
        [suit: "D", value: 2],
        [suit: "S", value: 3],
        [suit: "C", value: 5],
        [suit: "D", value: 8],
        [suit: "H", value: 11]
      ]

      assert Rank.get_pair(hand) == {}
    end

    test "get a pair from the hand" do
      hand = [
        [suit: "D", value: 2],
        [suit: "S", value: 3],
        [suit: "C", value: 5],
        [suit: "D", value: 5],
        [suit: "H", value: 11]
      ]

      assert Rank.get_pair(hand) == {:pair, 5}
    end

    test "get the highest pair from the hand" do
      hand = [
        [suit: "D", value: 3],
        [suit: "S", value: 3],
        [suit: "C", value: 5],
        [suit: "D", value: 5],
        [suit: "H", value: 11]
      ]

      assert Rank.get_pair(hand) == {:pair, 5}
    end
  end

  describe "group_by" do
    test "grouping by value" do
      cards = [
        [suit: "D", value: 3],
        [suit: "S", value: 3],
        [suit: "C", value: 5],
        [suit: "D", value: 5],
        [suit: "H", value: 11]
      ]

      assert Rank.group_by(cards, :value) == %{3 => 2, 5 => 2, 11 => 1}
    end

    test "groups more than 2" do
      cards = [
        [suit: "D", value: 3],
        [suit: "S", value: 3],
        [suit: "C", value: 3],
        [suit: "H", value: 3],
        [suit: "H", value: 13]
      ]

      assert Rank.group_by(cards, :value) == %{3 => 4, 13 => 1}
    end

    test "grouping by suit" do
      cards = [
        [suit: "D", value: 3],
        [suit: "S", value: 3],
        [suit: "C", value: 5],
        [suit: "D", value: 5],
        [suit: "H", value: 11]
      ]

      assert Rank.group_by(cards, :suit) == %{"C" => 1, "D" => 2, "H" => 1, "S" => 1}
    end
  end

  describe "get_four_of_a_kind" do
    test "returns empty if not found" do
      cards = [
        [suit: "D", value: 2],
        [suit: "S", value: 3],
        [suit: "C", value: 3],
        [suit: "D", value: 3],
        [suit: "H", value: 6]
      ]

      assert Rank.get_four_of_a_kind(cards) == {}
    end

    test "gets the rank and the value of the cards" do
      cards = [
        [suit: "H", value: 3],
        [suit: "S", value: 3],
        [suit: "C", value: 3],
        [suit: "D", value: 3],
        [suit: "H", value: 6]
      ]

      assert Rank.get_four_of_a_kind(cards) == {:four_of_a_kind, 3}
    end
  end

  describe "get_three_of_a_kind" do
    test "returns empty if not found" do
      cards = [
        [suit: "D", value: 2],
        [suit: "S", value: 3],
        [suit: "C", value: 3],
        [suit: "D", value: 7],
        [suit: "H", value: 9]
      ]

      assert Rank.get_three_of_a_kind(cards) == {}
    end

    test "gets the three_of_a_kind when three values match" do
      cards = [
        [suit: "D", value: 2],
        [suit: "S", value: 3],
        [suit: "C", value: 3],
        [suit: "D", value: 3],
        [suit: "H", value: 6]
      ]

      assert Rank.get_three_of_a_kind(cards) == {:three_of_a_kind, 3}
    end

    test "gets the rank and the value of the cards" do
      cards = [
        [suit: "H", value: 4],
        [suit: "S", value: 4],
        [suit: "C", value: 4],
        [suit: "D", value: 4],
        [suit: "H", value: 6]
      ]

      assert Rank.get_three_of_a_kind(cards) == {:three_of_a_kind, 4}
    end
  end
end
