defmodule MorelloWeb.Modal do
  use Surface.Component

  slot default
  prop show?, :boolean, default: false
  prop height, :string, default: "300px"

  def render(assigns) do
    ~F"""
    {#if @show?}
      <div class="modal-container">
        <div class="modal-content" style={"height: #{@height}"} >
	  <#slot />
	</div>
      </div>
    {/if}
    """
  end
end
