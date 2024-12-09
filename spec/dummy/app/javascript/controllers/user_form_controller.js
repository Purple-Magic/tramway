import { Controller } from "@hotwired/stimulus";

export default class UserForm extends Controller {
  connect() {
    console.log('User form controller connected');
  }

  updateForm() {
    alert('Works!');
  }
}

export { UserForm }
