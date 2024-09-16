import { Controller } from "@hotwired/stimulus";

export default class TableRowPreview extends Controller {
  static targets = ["main"]

  connect() {
    console.log('connected')
  }

  toggle() {
    console.log('work')
    // this.mainTarget.classList.toggle("hidden");
    document.getElementById("roll-up").classList.toggle("hidden");
  }
}

export { TableRowPreview }
