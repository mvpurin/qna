import consumer from "./consumer";

consumer.subscriptions.create({ channel: "AnswersChannel" }, {
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
    if (gon.user_id == data.answer.user_id) { return }
    console.log("received data: ", data)

    let answers = document.getElementsByClassName("answers")[0];
    answers.append(data.answer.title)
    answers.append(document.createElement("br"))
    answers.append(data.answer.body)
    answers.append(document.createElement("br"))
    answers.append("Rating: " + data.rating)
    answers.append(document.createElement("hr"))
  },
})