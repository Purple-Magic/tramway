import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    console.log("User form controller connected");k
  }

  updateForm() {
    // alert("Form updated");
  }
}
