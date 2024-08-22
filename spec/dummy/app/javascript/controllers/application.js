import { Application } from "@hotwired/stimulus"
import { Multiselect } from '@tramway/multiselect'

const application = Application.start()

application.debug = false
application.register('multiselect', Multiselect)
window.Stimulus   = application

export { application }
