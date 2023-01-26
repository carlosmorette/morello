export default {
  mounted() {
    this.handleEvent("js|home-hooks|get-all-columns", () => {
      this.pushEvent("elx|home-hooks|get-all-columns", {
	columns_json: localStorage.getItem("morelloweb")
      })
    })

    this.handleEvent("js|home-hooks|new-column", ({
      column: {
	id: id,
	title: title
    }}) => {
      const columns = JSON.parse(localStorage.getItem("morelloweb"))

      if (!columns) {
	localStorage.setItem(
	  "morelloweb",
	  JSON.stringify([{id: id, title: title, cards: []}]
	))
	return
      }

      const new_columns = columns.concat({id: id, title: title, cards: []})
      localStorage.setItem("morelloweb", JSON.stringify(new_columns))
      this.pushEvent("elx|home-hooks|card-created")
    })

    this.handleEvent("js|home-hooks|new-card", ({
      column: {
	title: title,
	id: column_id
      },
      card: {
	id: card_id,
	title: card_title,
	content: card_content
      }
    }) => {
      console.log("CRIAR CARD")
      const columns = JSON.parse(localStorage.getItem("morelloweb"))

      if (!columns) {
	localStorage.setItem("morelloweb", JSON.stringify([]))
	return
      }

      let column_index = columns.findIndex(c => c.id === column_id)

      const cards = columns[column_index]
	.cards
	.concat({
	  title: card_title,
	  content: card_content,
	  id: card_id
	})

      columns[column_index] = {...columns[column_index], cards: cards}

      localStorage.setItem("morelloweb", JSON.stringify(columns))
    })
  }
}
