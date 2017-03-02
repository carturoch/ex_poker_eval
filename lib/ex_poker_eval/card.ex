defmodule ExPokerEval.Card do
  @moduledoc """
  Card manipulation functions
  """

  @suits ~w(H D S C)
  @values ~w(J Q K) ++ [2..10]

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
    [parse_card(List.first(list))]
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
  def parse_card(bin) do
    with suit <- String.last(bin),
        true <- Enum.member?(@suits, suit),
        literal_value <- String.trim_trailing(bin, suit),
        value <- sym_to_num(literal_value)
    do
      {:ok, [suit: suit, value: value]}
    else
      _ -> {:error, :invalid_card}
    end
  end

  @doc """
  Converts symbolic values into numeric ones.

  ## Examples
  ```
  iex>ExPokerEval.Card.sym_to_num("2")
  2

  iex>ExPokerEval.Card.sym_to_num("Q")
  12

  iex>ExPokerEval.Card.sym_to_num("A")
  14
  ```
  """
  def sym_to_num("A"), do: 14
  def sym_to_num("J"), do: 11
  def sym_to_num("Q"), do: 12
  def sym_to_num("K"), do: 13
  def sym_to_num(bin) do
    Integer.parse(bin)
  end
end
