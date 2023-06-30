let gist = document.getElementById('gist-link');

import { gistClient } from "../application";

if (gist !== null) { gist.innerHTML = gistLoader() };

function gistLoader() {
  gistClient
    .setToken("#{ENV['GIST_TOKEN']}")
    .getOneById("#{link.gist_url}")
    .then(response => {
      for (let file in response.files) {
        let currentLink = document.querySelector('[id="link-#{link.id}"]')
        currentLink.firstChild.innerText = response.files[file].content
      }
    }).catch(err => {
      console.log(err)
    })
}    