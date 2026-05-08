import { Controller } from "@hotwired/stimulus"

export default class UiCheckbox extends Controller {
  static targets = ["input", "button", "indicator"]

  connect() {
    this.sync()
  }

  toggle(event) {
    event.preventDefault()

    if (this.inputTarget.disabled) return

    this.inputTarget.click()
    this.sync()
  }

  sync() {
    const checked = this.inputTarget.checked
    const state = checked ? "checked" : "unchecked"

    this.buttonTarget.setAttribute("aria-checked", checked.toString())
    this.buttonTarget.dataset.state = state
    this.buttonTarget.classList.toggle("border-zinc-50", checked)
    this.buttonTarget.classList.toggle("bg-zinc-50", checked)
    this.buttonTarget.classList.toggle("text-zinc-950", checked)
    this.buttonTarget.classList.toggle("border-zinc-800", !checked)
    this.buttonTarget.classList.toggle("bg-zinc-950", !checked)
    this.buttonTarget.classList.toggle("text-zinc-50", !checked)
    this.indicatorTarget.classList.toggle("hidden", !checked)
    this.buttonTarget.toggleAttribute("disabled", this.inputTarget.disabled)
  }
}

export { UiCheckbox }
