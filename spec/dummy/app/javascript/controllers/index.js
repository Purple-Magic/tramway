import { Application } from "@hotwired/stimulus"
import { Multiselect } from "@tramway/multiselect"
import { UserForm } from "./user_form_controller"

const application = Application.start()

application.debug = false
window.Stimulus   = application
application.register('multiselect', Multiselect)
application.register('user-form', UserForm)

export { application }
