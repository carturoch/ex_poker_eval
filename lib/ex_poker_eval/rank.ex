defmodule ExPokerEval.Rank do
  @moduledoc """
  Ranking functions for poker cards
  """

  @doc """
  Gets a straight if found
  """
  def get_straight(cards) do
    cards = cards
    |> Enum.map(&(&1[:value]))
    |> ace_as_one

    with lower <- cards |> List.first,
      upper <- cards |> List.last,
      sequence <- lower..upper |> Enum.to_list,
      true <- cards == sequence
    do
      {:straight, upper}
    else
      _ -> {}
    end
  end

  @doc """
  Helper to use Ace as value 1 when needed
  to complete a lower straight.

  ## Examples
  ```
  iex>ExPokerEval.Rank.ace_as_one([2,3,4,5,14])
  [1,2,3,4,5]

  iex>ExPokerEval.Rank.ace_as_one([14,2,3,4,5])
  [1,2,3,4,5]

  iex>ExPokerEval.Rank.ace_as_one([3,4,5,6,7])
  [3,4,5,6,7]
  ```
  """
  def ace_as_one([2,3,4,5,14]), do: [1,2,3,4,5]
  def ace_as_one([14,2,3,4,5]), do: [1,2,3,4,5]
  def ace_as_one(values), do: values

  @doc """
  Gets a flush, if present, with the higest value on it
  """
  def get_flush(cards) do
    cards
    |> group_by(:suit)
    |> Map.values
    |> Enum.member?(5)
    |> case do
        true -> {:flush, List.last(cards)[:value]}
        _ -> {}
      end
  end

  @doc """
  Gets a pair from a set of cards.
  If more than one is present the returned value will contain
  the highest one by value.
  """
  def get_pair(cards) do
    pairs = cards
    |> group_by(:value)
    |> Enum.filter(fn {_value, hits} -> hits > 1 end)

    case pairs do
      [] -> {}
      _ -> {:pair, pairs |> List.last |> Tuple.to_list |> List.first }
    end
  end

  @doc """
  Gets two pairs from a set of cards and returns the highest value.
  Each pair is expected to be of different value.
  """
  def get_two_pairs(cards) do
    pairs = cards
    |> group_by(:value)
    |> Enum.filter(fn {_value, hits} -> hits > 1 end)

    cond do
      length(pairs) > 1 ->
        {:two_pairs, pairs |> List.last |> Tuple.to_list |> List.first }
      true ->
        {}
    end
  end

  @doc """
  Gets the value of four_of_a_kind rank if present
  """
  def get_four_of_a_kind(cards) do
    {value, 4} = cards
    |> group_by(:value)
    |> Enum.find({0, 4}, fn {_value, hits} -> hits == 4 end)

    case value do
      0 -> {}
      _ -> {:four_of_a_kind, value }
    end
  end

  @doc """
  Gets the value of three_of_a rank if present
  """
  def get_three_of_a_kind(cards) do
    {value, _hits} = cards
    |> group_by(:value)
    |> Enum.find({0, 3}, fn {_value, hits} -> hits >= 3 end)

    case value do
      0 -> {}
      _ -> {:three_of_a_kind, value }
    end
  end

  @doc """
  Helper to group cards by the given field
  """
  def group_by(cards, field) do
    cards
    |> Enum.reduce(%{}, fn card, acc ->
        val = card[field]
        hits = case acc[val] do
          nil -> 1
          _ -> acc[val] + 1
        end
        Map.put(acc, val, hits)
      end)
  end
end
