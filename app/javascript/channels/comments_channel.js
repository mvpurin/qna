import consumer from "./consumer";

consumer.subscriptions.create({ channel: "CommentsChannel", question_id: gon.question_id }, {
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
    console.log("Received data: " + data)

    let comments = document.getElementsByClassName("comments")[0];
    comments.append(data.comment.body)
    comments.append(document.createElement("br"))
    comments.append(document.createElement("hr"))
  },
})