import { Application } from "@hotwired/stimulus"
import { Navbar, TramwaySelect, UiCheckbox, Tooltip } from "@tramway/tramway"
import { UserForm } from "./user_form_controller"

const application = Application.start()

application.debug = false
window.Stimulus   = application
application.register('tramway-navbar', Navbar)
application.register('tramway-select', TramwaySelect)
application.register('ui--checkbox', UiCheckbox)
application.register('tramway-tooltip', Tooltip)
application.register('user-form', UserForm)

export { application }
