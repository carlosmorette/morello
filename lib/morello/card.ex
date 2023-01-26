defmodule Morello.Card do
  defstruct id: nil, title: nil, content: nil

  def new_empty do
    %{
      id: UUID.uuid1(),
      title: "",
      content: ""
    }
  end

  def new(title: title, content: content) do
    %{
      id: UUID.uuid1(),
      title: title,
      content: content
    }
  end

  def format_to_atom(cards), do: format_to_atom(cards, [])

  def format_to_atom([], acc), do: acc

  def format_to_atom([%{"id" => id, "title" => title, "content" => content} | cards], acc) do
    format_to_atom(cards, [
      %{
        id: id,
        title: title,
        content: content
      }
      | acc
    ])
  end
end
