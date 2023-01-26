defmodule Morello.Column do
  defstruct id: nil, title: nil, cards: []

  def format_to_atom(columns), do: format_to_atom(columns, [])

  def format_to_atom([], acc), do: acc

  def format_to_atom(
        [
          %{"id" => id, "title" => title, "cards" => cards}
          | columns
        ],
        acc
      ) do
    format_to_atom(columns, [
      %{
        id: id,
        title: title,
        cards: Morello.Card .format_to_atom(cards)
      }
      | acc
    ])
  end
end
