defmodule ExPokerEval.Rank do
  @moduledoc """
  Ranking functions for poker hands
  """

  @doc """
  Gets a straight if found
  """
  def get_straight(hand) do
    cards = hand
    |> Enum.map(&(&1[:value]))
    |> Enum.sort
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
  """
  def ace_as_one([2,3,4,5,14]), do: [1,2,3,4,5]
  def ace_as_one(values), do: values

end
