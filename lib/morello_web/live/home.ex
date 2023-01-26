defmodule MorelloWeb.HomeLive do
  use Surface.LiveView

  alias Morello.Column
  alias MorelloWeb.Column, as: ColumnComponent
  alias MorelloWeb.Header

  data columns, :list, default: []

  data title_new_column_input, :string, default: ""

  def mount(_params, _session, socket) do
    {:ok, get_all_columns(socket)}
  end

  def render(assigns) do
    ~F"""
    <div>
    <div :hook id="home">
      <Header>
        <div>
    <form>
     <div class="field">
       <label for="column-title">Título:</label>
         <input 
         id="column-title"
         name="column-title" 
         placeholder="Título da coluna" 
         :on-change="change-input-title"
       />
     </div>
    </form>
    <button :on-click="add-new-column">Adicionar coluna</button>
    </div>
      </Header>
    </div>

    <div class="columns-container">
      {#for %{id: column_id, title: title, cards: cards} <- @columns}
        <div class="column">
    <ColumnComponent
      id={column_id}
      cards={cards} 
      title={title} 
     columns={@columns}
    />
    </div>
      {/for}
    </div>
    </div>
    """
  end

  def get_all_columns(socket) do
    push_event(socket, "js|home-hooks|get-all-columns", %{})
  end

  def handle_event("elx|home-hooks|get-all-columns", %{"columns_json" => nil}, socket) do
    {:noreply, socket}
  end

  def handle_event(
        "elx|home-hooks|get-all-columns",
        %{
          "columns_json" => "null"
        },
        socket
      ) do
    {:noreply, socket}
  end

  def handle_event("elx|home-hooks|get-all-columns", %{"columns_json" => columns_json}, socket) do
    {:noreply,
     update(socket, :columns, fn _columns ->
       columns_json
       |> Jason.decode!()
       |> Column.format_to_atom()
     end)}
  end

  def handle_event("add-new-column", _params, socket) do
    {:noreply,
     push_event(socket, "js|home-hooks|new-column", %{
       column: %{
         id: UUID.uuid1(),
         title: socket.assigns[:title_new_column_input]
       }
     })}
  end

  def handle_event("change-input-title", %{"column-title" => title}, socket) do
    {:noreply, update(socket, :title_new_column_input, fn _curr_value -> title end)}
  end

  def handle_event(
        "confirm-create-new-card",
        %{
          "card-content" => card_content,
          "card-title" => card_title,
          "column-id" => column_id,
          "column-title" => column_title
        },
        socket
      ) do
    {:noreply,
     push_event(socket, "js|home-hooks|new-card", %{
       column: %{
         id: column_id,
         title: column_title
       },
       card: %{
         id: UUID.uuid1(),
         title: card_title,
         content: card_content
       }
		})}
    |>
  end

  def handle_event("elx|home-hooks|edited-card", _params, socket) do
    {:noreply, push_navigate(socket, to: "/")}
  end

  def handle_event("elx|home-hooks|card-created", _params, socket) do
    {:noreply, push_navigate(socket, to: "/")}
  end
end
