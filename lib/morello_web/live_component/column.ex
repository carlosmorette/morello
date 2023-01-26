defmodule MorelloWeb.Column do
  use Surface.LiveComponent

  alias MorelloWeb.{Card, Modal}

  prop cards, :list, default: []
  prop title, :string, required: true
  prop columns, :list, required: true

  data create_card_modal_is_open?, :boolean, default: false

  data title_input, :string, default: ""
  data content_input, :string, default: ""

  def render(assigns) do
    ~F"""
    <div>
      <div class="column-header" id={"column-container-#{@id}"}>
        <p>{@title}</p>
	  <p :on-click="show-modal" phx-value-column_id={@id}>+</p>
      </div>
      {#for %{content: content, title: title, id: id} <- @cards}
        <Card 
	  id={id}
	  content={content} 
	  title={title} 
	  columns={@columns}
	  column_id={@id}
	/>
      {/for}

    <Modal show?={@create_card_modal_is_open?}>
         <h2>Novo Card</h2>
         <div class="modal-content-fields">
       	  <form>
       	    <div class="field">
       	      <label for="title">Título:</label>
       	      <input id="title" :on-change="title-input-change" name="title" />
       	    </div>

             <div class="field">
               <label for="content">Conteúdo:</label>
       	      <textarea 
                id="content" 
       		:on-change="content-input-change" 
       		name="content" 
       		style="resize: none"
       	      ></textarea>
             </div>
           </form>
         </div>
         <button 
	   phx-click="confirm-create-new-card"
	   phx-value-column-title={@title}
	   phx-value-card-title={@title_input}
	   phx-value-card-content={@content_input}
	   phx-value-column-id={@id}
	   >Criar</button>
       </Modal>
    </div>
    """
  end

  def handle_event("show-modal", _params, socket) do
    {:noreply, update(socket, :create_card_modal_is_open?, fn false -> true end)}
  end

  def handle_event("title-input-change", %{"title" => value}, socket) do
    {:noreply, change_state(:title_input, value, socket)}
  end

  def handle_event("content-input-change", %{"content" => value}, socket) do
    {:noreply, change_state(:content_input, value, socket)}
  end

  def change_state(field, value, socket) do
    update(socket, field, fn _curr_value -> value end)
  end
end
