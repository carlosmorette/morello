export default {
  mounted() {
    this.handleEvent("js|card-hooks|edit-card", ({
      title: title,
      content: content,
      card_id: card_id,
      column_id: column_id
    } = params) => {
      const columns = JSON.parse(localStorage.getItem("morelloweb"))
      const column_index = columns.findIndex(c => c.id === column_id)

      const column = columns[column_index]

      const card_index = columns[column_index].cards.findIndex(c => c.id === card_id)

      column.cards[card_index] = {...column.cards[card_index], title: title, content: content}

      localStorage.setItem("morelloweb", JSON.stringify(columns))
      this.pushEvent("elx|home-hooks|edited-card")
    })
  }
}
