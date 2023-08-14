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
    if (data.comment.commentable_type == "Question") {
      var comments = document.getElementsByClassName("question-comments")[0]
    } else {
      let answerId = data.comment.commentable_id
      var comments = document.getElementById("answer-" + answerId + "-comments")
    }

    comments.append(data.comment.body)
    comments.append(document.createElement("br"))
    comments.append(document.createElement("hr"))
  },
})