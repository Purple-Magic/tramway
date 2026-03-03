# frozen_string_literal: true

pin 'application'
pin '@tramway/tramway-select', to: 'tramway/tramway-select_controller.js'
pin '@hotwired/stimulus', to: 'stimulus.min.js'
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'
pin_all_from 'app/javascript/controllers', under: 'controllers'
