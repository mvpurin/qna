import consumer from "./consumer";

consumer.subscriptions.create({ channel: "QuestionsChannel", question_id: gon.question_id }, {
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
    console.log("received data: ", data.question)
  },
})
