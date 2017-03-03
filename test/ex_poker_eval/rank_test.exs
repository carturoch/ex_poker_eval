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
end
