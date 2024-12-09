import { Application } from "@hotwired/stimulus"
import { Multiselect } from "@tramway/multiselect"
import UserFormController from "controllers/user_form_controller"

const application = Application.start()

application.debug = false
application.register('multiselect', Multiselect)
application.register('user-form', UserFormController)
window.Stimulus   = application

export { application }
