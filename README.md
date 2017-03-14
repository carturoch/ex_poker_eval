# ExPokerEval

Elixir implementation of a poker's hand evaluator.

## Usage

```elixir
ExPokerEval.get_highest(
  black: ~w(2H 3D 5S 9C KD),
  white: ~w(2C 3H 4S 8C AH)
)

# Output: {:white, :high_card, "Ace"}

ExPokerEval.get_highest(
  black: ~w(2H 3D 5S 9C KD),
  white: ~w(2D 3H 5C 9S KH)
)

# Output: {:tie}

```

_Supports ♥♠♦♣ for suits_
