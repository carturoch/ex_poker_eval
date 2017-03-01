defmodule ExPokerEval.Card do
  @moduledoc """
  Card manipulation functions
  """

  @doc """
  Gets an array of cards as a keyword of cards represented by
  value and suit.

  ## Examples
  ```
  iex>ExPokerEval.Card.parse_hand(~w(KD))
  [[suit: D, value: 13]]

  ```
  """
  def parse_hand(list) do
    list
    |> Enum.map(fn item -> [suit: H, value: 1] end)
  end

  @doc """
  Parses a card out of a string

  ## Examples
  ```
  iex>ExPokerEval.Card.parse_card("KD")
  {:ok, [suit: D, value: 13]}

  iex>ExPokerEval.Card.parse_card("1H")
  {:ok, [suit: H, value: 14]}

  iex>ExPokerEval.Card.parse_card("9S")
  {:ok, [suit: S, value: 9]}

  iex>ExPokerEval.Card.parse_card("5Z")
  {:error, :invalid_card}
  ```
  """
  def parse_card(str) do
    
  end
end
