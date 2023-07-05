// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// https://stackoverflow.com/questions/70921378/how-to-install-jquery-and-bootstrap-in-rails-7-app-using-esbuild-without-webpac
import "jquery"
import "jquery_ujs"
import "popper"
import "bootstrap"

import "@rails/activestorage"
import "@nathanvda/cocoon"

import GistClient from "gist-client"
const gistClient = new GistClient()
window.gistClient = gistClient

// Custom JS files
import "utilities/edit_answer"
import "utilities/edit_question"

window.gistLoader = function gistLoader(gist_url, id) {
  gistClient
    .setToken(document.head.querySelector("meta[name=gist_token]").content)
    .getOneById(gist_url)
    .then(response => {
      for (let file in response.files) {
        let currentLink = document.getElementById('link-' + id)
        currentLink.firstChild.innerText = response.files[file].content
      }
    }).catch(err => {
      console.log(err)
    })
};

window.loadGists = function loadGists() {
  let gistLinks = document.getElementsByClassName('gist-link');
  if (gistLinks) {
    for (let i = 0; i < gistLinks.length; i++) {
      let url = gistLinks[i].getAttribute("data-gist-url");
      let id = gistLinks[i].getAttribute("data-gist-id");
      gistLoader(url, id);
    };
  }
}

loadGists();
