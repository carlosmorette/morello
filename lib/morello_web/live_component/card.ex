defmodule MorelloWeb.Card do
  use Surface.LiveComponent

  alias Surface.Components.Form.Select

  alias MorelloWeb.Modal

  prop content, :string, required: true
  prop title, :string, required: true

  prop columns, :list, required: true

  prop column_id, :string, required: true

  data edit_modal_is_open?, :boolean, default: false

  data edited_content, :string, default: ""
  data edited_title, :string, default: ""

  def render(assigns) do
    ~F"""
    <div :hook>
    <div
      class="container-card" 
      draggable="true" 
      ondragstart="drag(event)"
      :on-click="card-open"
      >
      {"#{String.slice(@title, 0, 10)}#{if(String.length(@title) >= 10, do: "...")}"}
    </div>

    <Modal show?={@edit_modal_is_open?} height={"300px"}>
      <h2>Editar Card</h2>
        <div class="modal-content-fields">
        <form>
          <div class="field">
            <label for="title">Título:</label>
            <input id="edit-title" :on-change="edit-title-input-change" name="title" value={@title} />
          </div>

          <div class="field">
            <label for="content">Conteúdo:</label>
       	    <textarea 
              id="edit-content" 
       	      :on-change="edit-content-input-change" 
       	      name="content" 
       	      style="resize: none">{@content}</textarea>
     </div>

         <div class="field">
    <label for="content">Colunas:</label>
    <Select options={Enum.map(@columns, fn c -> c.title end)} />
    </div>
       </form>
     </div>
    <button :on-click="confirm-edit-card">Editar</button>
    </Modal>
    </div>
    """
  end

  def handle_event("confirm-edit-card", _params, socket) do
    edited_title = socket.assigns[:edited_title]

    edited_title =
      if no_edited?(edited_title) do
        socket.assigns[:title]
      else
        edited_title
      end

    edited_content = socket.assigns[:edited_content]

    edited_content =
      if no_edited?(edited_content) do
        socket.assigns[:content]
      else
        edited_content
      end

    _edited_column = nil

    card_id = socket.assigns[:id]
    column_id = socket.assigns[:column_id]

    {:noreply,
     socket
     |> push_event("js|card-hooks|edit-card", %{
       title: edited_title,
       content: edited_content,
       card_id: card_id,
       column_id: column_id
     })}
  end

  def handle_event("edit-title-input-change", %{"title" => value}, socket) do
    {:noreply, change_state(:edited_title, value, socket)}
  end

  def handle_event("edit-content-input-change", %{"content" => value}, socket) do
    {:noreply, change_state(:edited_content, value, socket)}
  end

  def handle_event("edit-column-select-change", params, socket)do
    IO.inspect(params, label: "=== PARAMS ===")
    {:noreply, socket}
  end

  def handle_event("card-open", _params, socket) do
    {:noreply, update(socket, :edit_modal_is_open?, fn false -> true end)}
  end

  def change_state(field, value, socket) do
    update(socket, field, fn _curr_value -> value end)
  end

  defp no_edited?(""), do: true
  defp no_edited?(_value), do: false
end
