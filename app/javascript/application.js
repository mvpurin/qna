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
