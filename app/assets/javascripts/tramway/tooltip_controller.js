import { Controller } from "@hotwired/stimulus"

export default class Tooltip extends Controller {
  static targets = ["panel"]

  toggle(event) {
    event.stopPropagation()

    this.panelTarget.classList.toggle("hidden")
  }

  closeOnClickOutside(event) {
    if (this.element.contains(event.target)) return

    this.panelTarget.classList.add("hidden")
  }
}

export { Tooltip }
