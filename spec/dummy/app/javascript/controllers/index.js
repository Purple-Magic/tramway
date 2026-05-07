import { Application } from "@hotwired/stimulus"
import { TramwaySelect } from "@tramway/tramway-select"
import { Checkbox } from "@tramway/checkbox"
import { UserForm } from "./user_form_controller"

const application = Application.start()

application.debug = false
window.Stimulus   = application
application.register('tramway-select', TramwaySelect)
application.register('tramway-checkbox', Checkbox)
application.register('user-form', UserForm)

export { application }
