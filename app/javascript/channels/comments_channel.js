import consumer from "./consumer";

consumer.subscriptions.create({ channel: "CommentsChannel" }, {
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
    let ul = comments.getElementsByClassName("comments")[0]
    let li = document.createElement("li")
    li.innerHTML = data.comment.body
    ul.appendChild(li)
  },
})