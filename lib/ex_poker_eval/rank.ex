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
