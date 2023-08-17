import consumer from "./consumer";

consumer.subscriptions.create({ channel: "QuestionsChannel" }, {
  initialized() {
    this.update = this.update.bind(this)
  },

  update() {
    this.documentIsActive ? this.appear() : this.away()
  },

  connected() {
    console.log("Connected to the channel: ", this)
  },

  received(data) {
    alert(data.question.title)
    console.log("received data: ", data.question)
  },
})
