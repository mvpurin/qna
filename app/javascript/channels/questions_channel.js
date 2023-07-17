import consumer from "./consumer";

consumer.subscriptions.create("QuestionsChannel", {
  initialized() {
    this.update = this.update.bind(this)
  },
  update() {
    this.documentIsActive ? this.appear() : this.away()
  },
  connected() {
    console.log("Connected!")
    this.perform("follow")
  },
  received(data) {
    let questionsList = document.getElementsByClassName("questions");
    questionsList.append(data);
  }
})