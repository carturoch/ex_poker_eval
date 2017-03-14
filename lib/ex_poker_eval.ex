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
      {:ok, w_cards} <- Card.parse_hand(w_hand),
      comparison <- compare(b_cards, w_cards)
      do
        comparison |> decorate_result
      else
        {:error, msg} -> {:error, msg}
        _ -> {:error, :other}
      end
  end

  @doc """
  Compares two sets of parsed cards recursively until
  a winer is found or returns :tie
  """
  def compare(b, w), do: compare(b, w, 0)
  def compare(b_cards, w_cards, offset) do
    {b_idx, b_rank, b_value} = Rank.highest(b_cards, offset)
    {w_idx, w_rank, w_value} = Rank.highest(w_cards, offset)

    cond do
      b_idx < w_idx -> {:black, b_rank, b_value}
      b_idx > w_idx -> {:white, w_rank, w_value}
      b_value > w_value -> {:black, b_rank, b_value}
      b_value < w_value -> {:white, w_rank, w_value}
      b_rank == :high_card -> compare_high_cards(b_cards, w_cards)
      true -> compare(b_cards, w_cards, offset + 1)
    end
  end

  @doc """
  Compares two sets of cards just by their higest cards
  """
  def compare_high_cards(b_cards, w_cards) do
    b_values = b_cards |> Enum.map(&(&1[:value])) |> Enum.reverse
    w_values = w_cards |> Enum.map(&(&1[:value])) |> Enum.reverse

    distinct_pair = Enum.zip(b_values, w_values)
    |> Enum.reject(fn {b, w} -> b == w end)
    |> List.first

    case distinct_pair do
      {b, w} when b > w -> {:black, :high_card, b}
      {b, w} when b < w -> {:white, :high_card, w}
      _ -> :tie
    end
  end

  @doc """
  Processes the result to use symbolic values instead of numeric unless is a tie.

  ## Examples
  ```
  iex>ExPokerEval.decorate_result(:tie)
  :tie

  iex>ExPokerEval.decorate_result({:white, :flush, 14})
  {:white, :flush, "Ace"}
  ```
  """
  def decorate_result(:tie), do: :tie
  def decorate_result({winer, rank, value}), do: {winer, rank, Card.num_to_sym(value)}
end
