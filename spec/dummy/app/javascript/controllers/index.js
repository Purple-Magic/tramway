// import { application } from "controllers/application"
// import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
// import { Multiselect } from "@tramway/multiselect"
// import UserFormController from "controllers/user_form_controller"
// eagerLoadControllersFrom("controllers", application)

// application.register('multiselect', Multiselect)
// application.register('user-form', UserFormController)

// import { application } from "controllers/application"

// Eager load all controllers defined in the import map under controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

