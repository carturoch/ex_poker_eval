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

  @straight_lowest_cards [
    [suit: "H", value: "A"],
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

  describe "get_straight" do
    test "return empty tuple if not found" do
      assert Rank.get_straight(@highcard_cards) == {}
    end

    test "get the lower straight" do
      assert Rank.get_straight(@straight_middle_cards) == {:straight, []}
    end
  end
end
