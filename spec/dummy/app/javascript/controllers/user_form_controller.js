import { Controller } from "@hotwired/stimulus";

export default class UserForm extends Controller {
  connect() {
    window.console.log('User form controller connected');
  }

  updateForm() {
    window.console.log('Form updated');
  }
}

export { UserForm }
