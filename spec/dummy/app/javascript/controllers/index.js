// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import { Multiselect } from "@tramway/multiselect"
eagerLoadControllersFrom("controllers", application)

application.register('multiselect', Multiselect)
