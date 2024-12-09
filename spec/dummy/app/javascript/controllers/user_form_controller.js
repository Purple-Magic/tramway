import { Controller } from "@hotwired/stimulus";

export default class UserFormController extends Controller {
  connect() {
    console.log("User form controller connected");k
  }

  updateForm() {
    alert("Form updated");
  }
}
