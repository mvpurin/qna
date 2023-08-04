import consumer from "./consumer";

consumer.subscriptions.create({ channel: "AnswersChannel", question_id: gon.question_id }, {
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
    if (gon.user_id == data.user_id) { return }
    console.log("received data: ", data)

    let answers = document.getElementsByClassName("answers")
    answers.append(JST["templates/answer"](data))
  },
})