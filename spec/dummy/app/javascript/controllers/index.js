import { Application } from "@hotwired/stimulus"
import { TramwaySelect, TableRowPreview, UiCheckbox, Tooltip } from "@tramway/tramway"
import { UserForm } from "./user_form_controller"

const application = Application.start()

application.debug = false
window.Stimulus   = application
application.register('tramway-select', TramwaySelect)
application.register('table-row-preview', TableRowPreview)
application.register('ui--checkbox', UiCheckbox)
application.register('tramway-tooltip', Tooltip)
application.register('user-form', UserForm)

export { application }
