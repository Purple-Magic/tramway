import { Controller } from "@hotwired/stimulus"

export default class Checkbox extends Controller {
  static targets = ["button", "indicator", "input"]

  connect() {
    this.sync()
  }

  toggle(event) {
    event.preventDefault()
    if (this.inputTarget.disabled) return

    this.inputTarget.checked = !this.inputTarget.checked
    this.inputTarget.dispatchEvent(new Event("change", { bubbles: true }))
    this.sync()
  }

  sync() {
    const checked = this.inputTarget.checked

    this.buttonTarget.dataset.state = checked ? "checked" : "unchecked"
    this.buttonTarget.setAttribute("aria-checked", checked ? "true" : "false")
    this.indicatorTarget.classList.toggle("hidden", !checked)
  }
}

export { Checkbox }
