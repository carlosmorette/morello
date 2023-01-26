defmodule MorelloWeb.Header do
  use Surface.Component

  slot default

  def render(assigns) do
    ~F"""
    <header class="header-container">
      <#slot />
    </header>
    """
  end
end
