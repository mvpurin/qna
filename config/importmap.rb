# Pin npm packages by running ./bin/importmap

pin 'application', preload: true
pin '@hotwired/turbo-rails', to: 'turbo.min.js', preload: true
pin '@hotwired/stimulus', to: 'stimulus.min.js', preload: true
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: true
pin_all_from 'app/javascript/controllers', under: 'controllers'
pin '@rails/ujs', to: 'https://ga.jspm.io/npm:@rails/ujs@7.0.4-3/lib/assets/compiled/rails-ujs.js'

pin 'jquery', to: 'jquery.min.js', preload: true
pin 'jquery_ujs', to: 'jquery_ujs.js', preload: true

pin_all_from 'app/javascript/utilities', under: 'utilities'

# https://stackoverflow.com/questions/71632824/rails-7-view-and-direct-upload-image-from-browser-client
pin '@rails/activestorage', to: 'https://ga.jspm.io/npm:@rails/activestorage@7.0.2/app/assets/javascripts/activestorage.esm.js'
