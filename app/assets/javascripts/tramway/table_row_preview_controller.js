import { Controller } from "@hotwired/stimulus";

export default class TableRowPreview extends Controller {
  static targets = ["main"]

  static values = {
    cells: Array,
  }

  connect() {
    console.log('connected')
    this.items = JSON.parse(this.element.dataset.items)
  }

  toggle() {
    console.log('work')
    // this.mainTarget.classList.toggle("hidden");
    document.getElementById("roll-up").classList.toggle("hidden");
  }
}

export { TableRowPreview }
