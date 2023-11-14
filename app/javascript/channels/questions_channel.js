import consumer from "channels/consumer";

consumer.subscriptions.create({ channel: "QuestionsChannel" }, {
  initialized() {
    this.update = this.update.bind(this)
  },

  update() {
    this.documentIsActive ? this.appear() : this.away()
  },

  connected() {
    console.log("Connected to the channel: ", this)
    console.log("Stream from question:" + gon.question_id)
  },

  received(data) {
    let questions = document.getElementsByClassName("questions")[0]
    questions.append(data.question.title)
    questions.append(document.createElement("br"))
    questions.append(data.question.body)
    questions.append(document.createElement("br"))
    questions.append("Rating: " + data.rating)
  },
})
