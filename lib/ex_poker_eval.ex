defmodule ExPokerEval do
  @moduledoc """
  Documentation for ExPokerEval.
  """

  alias ExPokerEval.Card
  alias ExPokerEval.Rank

  @doc """
  Gets the higest ranked hand from the two given
  """
  def get_highest(black: b_hand, white: w_hand) do
    with {:ok, b_cards} <- Card.parse_hand(b_hand),
      {:ok, w_cards} <- Card.parse_hand(w_hand)
      do
        [black: b_cards, white: w_cards]
      else
        {:error, msg} -> {:error, msg}
        _ -> {:error, :other}
      end
  end

  @doc """
  Compares two sets of parsed cards recursively until
  a winer is found or returns :tie
  """
  def compare(b_cards, w_cards) do
    {b_idx, b_rank, b_value} = Rank.highest(b_cards)
    {w_idx, w_rank, w_value} = Rank.highest(w_cards)

    cond do
      b_idx < w_idx -> {:black, b_rank, b_value}
      b_idx > w_idx -> {:white, w_rank, w_value}
      true -> :tie
    end
  end
end
