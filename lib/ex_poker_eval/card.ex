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
  {:ok, [[suit: D, value: 13]]}

  iex>ExPokerEval.Card.parse_hand(~w(KD 8Z 5H))
  {:error, :invalid_card_in_hand}

  # A hand might has a maximum of 5 cards

  iex>ExPokerEval.Card.parse_hand(~w(KD 8Z 5H KD 8Z 5H))
  {:error, :invalid_hand_size}

  # Cards can't be repeated

  iex>ExPokerEval.Card.parse_hand(~w(KD 8Z 8Z 5H))
  {:error, :repeated_card}

  iex>ExPokerEval.Card.parse_hand(~w(2H 3D 5S 9C KD))
  {:ok, [[suit: "H", value: 2], [suit: "D", value: 3], [suit: "S", value: 5], [suit: "C", value: 9], [suit: "D", value: 13]]}

  ```
  """
  def parse_hand(larger_hand) when length(larger_hand) > 5, do: {:error, :invalid_hand_size}
  def parse_hand(list) do
    with true <- length(Enum.uniq(list)) == length(list),
      cards <- Enum.map(list, &parse_card/1)
    do
      {:not_yet, cards}
    else
      false -> {:error, :repeated_card}
      _ -> {:error, :invalid_card_in_hand}
    end
  end

  @doc """
  Parses a card out of a string

  ## Examples
  ```
  iex>ExPokerEval.Card.parse_card("KD")
  {:ok, [suit: "D", value: 13]}

  iex>ExPokerEval.Card.parse_card("1H")
  {:ok, [suit: "H", value: 14]}

  iex>ExPokerEval.Card.parse_card("9S")
  {:ok, [suit: "S", value: 9]}

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

  iex>ExPokerEval.Card.sym_to_num("89")
  :error

  iex>ExPokerEval.Card.sym_to_num("7.6")
  :error

  iex>ExPokerEval.Card.sym_to_num("")
  :error
  ```
  """
  def sym_to_num("1"), do: 14
  def sym_to_num("A"), do: 14
  def sym_to_num("J"), do: 11
  def sym_to_num("Q"), do: 12
  def sym_to_num("K"), do: 13
  def sym_to_num(bin) do
    case Integer.parse(bin) do
      {num, ""} when num in 2..14 -> num
      _ -> :error
    end
  end

end
