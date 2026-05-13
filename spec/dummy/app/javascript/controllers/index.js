import { Application } from "@hotwired/stimulus"
import { TramwaySelect } from "@tramway/tramway-select"
import { UiCheckbox } from "@tramway/checkbox"
import { Tooltip } from "@tramway/tooltip"
import { UserForm } from "./user_form_controller"

const application = Application.start()

application.debug = false
window.Stimulus   = application
application.register('tramway-select', TramwaySelect)
application.register('ui--checkbox', UiCheckbox)
application.register('tramway-tooltip', Tooltip)
application.register('user-form', UserForm)

export { application }
