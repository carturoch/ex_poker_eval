defmodule ExPokerEval.Card do
  @moduledoc """
  Card manipulation functions
  """

  @suits ~w(H D S C)

  @doc """
  Gets an array of cards as a keyword of cards represented by
  value and suit.

  ## Examples
  ```

  iex>ExPokerEval.Card.parse_hand(~w(KD))
  {:ok, [[suit: "D", value: 13]]}

  iex>ExPokerEval.Card.parse_hand(~w(KD 8Z 5H))
  {:error, :invalid_card_in_hand}

  # A hand might has a maximum of 5 cards and
  # cannot be empty

  iex>ExPokerEval.Card.parse_hand(~w(KD 8Z 5H KD 8Z 5H))
  {:error, :invalid_hand_size}

  iex>ExPokerEval.Card.parse_hand([])
  {:error, :invalid_hand_size}

  # Cards can't be repeated

  iex>ExPokerEval.Card.parse_hand(~w(KD 8Z 8Z 5H))
  {:error, :repeated_card}

  iex>ExPokerEval.Card.parse_hand(~w(2H 3D 5S 9C KD))
  {:ok, [[suit: "H", value: 2], [suit: "D", value: 3], [suit: "S", value: 5], [suit: "C", value: 9], [suit: "D", value: 13]]}

  iex>ExPokerEval.Card.parse_hand(~w(2♠ 3♦))
  {:ok, [[suit: "S", value: 2], [suit: "D", value: 3]]}

  ```
  """
  def parse_hand([]), do: {:error, :invalid_hand_size}
  def parse_hand(larger_hand) when length(larger_hand) > 5, do: {:error, :invalid_hand_size}
  def parse_hand(list) do
    with true <- length(Enum.uniq(list)) == length(list),
      parsed_cards <- Enum.map(list, &parse_card/1),
      {:invalid_cards, []} <- {:invalid_cards, Keyword.get_values(parsed_cards, :error)},
      cards <- Keyword.get_values(parsed_cards, :ok)
    do
      {:ok, cards}
    else
      false -> {:error, :repeated_card}
      {:invalid_cards, [_]} -> {:error, :invalid_card_in_hand}
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
    with literal_suit <- String.last(bin),
        {:ok, suit} <- parse_suit(literal_suit),
        literal_value <- String.trim_trailing(bin, literal_suit),
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
  {:error, :invalid_card_value}

  iex>ExPokerEval.Card.sym_to_num("7.6")
  {:error, :invalid_card_value}

  iex>ExPokerEval.Card.sym_to_num("")
  {:error, :invalid_card_value}
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
      _ -> {:error, :invalid_card_value}
    end
  end

  @doc """
  Converts cards values into their symbol

  ## Examples
  ```
  iex>ExPokerEval.Card.num_to_sym(4)
  4

  iex>ExPokerEval.Card.num_to_sym(14)
  "Ace"

  iex>ExPokerEval.Card.num_to_sym(1)
  "Ace"

  iex>ExPokerEval.Card.num_to_sym(11)
  "Jack"

  iex>ExPokerEval.Card.num_to_sym(12)
  "Queen"

  iex>ExPokerEval.Card.num_to_sym(13)
  "King"

  iex>ExPokerEval.Card.num_to_sym(23)
  {:error, :invalid_card_value}
  ```
  """
  def num_to_sym(invalid_value) when not invalid_value in 1..14, do: {:error, :invalid_card_value}
  def num_to_sym(ace) when ace == 1 or ace == 14, do: "Ace"
  def num_to_sym(11), do: "Jack"
  def num_to_sym(12), do: "Queen"
  def num_to_sym(13), do: "King"
  def num_to_sym(num), do: num

  @doc """
  Parses the suit from the card. Supports UTF-8 chars

  ## Examples
  ```
  iex>ExPokerEval.Card.parse_suit("F")
  {:error, :invalid_suit}

  iex>ExPokerEval.Card.parse_suit("S")
  {:ok, "S"}

  iex>ExPokerEval.Card.parse_suit("♠")
  {:ok, "S"}

  iex>ExPokerEval.Card.parse_suit("♥")
  {:ok, "H"}

  iex>ExPokerEval.Card.parse_suit("♦")
  {:ok, "D"}

  iex>ExPokerEval.Card.parse_suit("♣")
  {:ok, "C"}
  ```
  """
  def parse_suit(bin) when bin in @suits, do: {:ok, String.upcase(bin)}
  def parse_suit("♠"), do: {:ok, "S"}
  def parse_suit("♥"), do: {:ok, "H"}
  def parse_suit("♣"), do: {:ok, "C"}
  def parse_suit("♦"), do: {:ok, "D"}
  def parse_suit(_wrong_suite), do: {:error, :invalid_suit}
end
