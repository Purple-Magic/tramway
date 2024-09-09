import { Controller } from "@hotwired/stimulus"

export default class Multiselect extends Controller {
  static targets = ["dropdown", "showSelectedArea", "hiddenInput"];

  static values = {
    items: Array,
    dropdownContainer: String,
    itemContainer: String,
    selectedItemTemplate: String,
    dropdownState: String,
    selectedItems: Array,
    placeholder: String,
    selectAsInput: String,
    value: Array
  }

  connect() {
    this.dropdownState = 'closed';
    this.unselectedItems = JSON.parse(this.element.dataset.items).map((item) => {
      return {
        text: item.text,
        value: item.value.toString()
      }
    });

    const initialValues = this.element.dataset.value === undefined ? [] : this.element.dataset.value.split(',')
    this.selectedItems = this.unselectedItems.filter(item => initialValues.includes(item.value));
    this.unselectedItems = this.unselectedItems.filter(item => !initialValues.includes(item.value));

    this.renderSelectedItems();
  }

  renderSelectedItems() {
    const allItems = this.fillTemplate(this.element.dataset.selectedItemTemplate, this.selectedItems);
    this.showSelectedAreaTarget.innerHTML = allItems;
    this.showSelectedAreaTarget.insertAdjacentHTML("beforeEnd", this.input());
    this.updateInputOptions();
  }

  fillTemplate(template, items) {
    return items.map((item) => {
      return template.replace(/{{text}}/g, item.text).replace(/{{value}}/g, item.value)
    }).join('')
  }

  closeOnClickOutside(event) {
    if (this.dropdownState === 'open' && !this.element.contains(event.target)) {
      this.closeDropdown();
    }
  }

  toggleDropdown() {
    if (this.dropdownState === 'closed') {
      this.openDropdown();
    } else {
      this.closeDropdown();
    }
  }

  rerenderItems() {
    this.closeDropdown();
    this.openDropdown();
  }

  openDropdown() {
    this.dropdownState = 'open';
    this.dropdownTarget.insertAdjacentHTML("afterend", this.template);

    if (this.dropdown()) {
      this.dropdown().addEventListener('click', event => event.stopPropagation());
    }
  }

  dropdown() {
    return this.element.querySelector('#dropdown');
  }

  closeDropdown() {
    this.dropdownState = 'closed';
    if (this.dropdown()) {
      this.dropdown().remove();
    }
  }

  get template() {
    return this.element.dataset.dropdownContainer.replace(
      /{{content}}/g,
      this.fillTemplate(this.element.dataset.itemContainer, this.unselectedItems)
    );
  }

  toggleItem({ currentTarget }) {
    const item = {
      text: currentTarget.dataset.text,
      value: currentTarget.dataset.value
    };

    const itemIndex = this.selectedItems.findIndex(x => x.value === item.value);
    if (itemIndex !== -1) {
      this.selectedItems = this.selectedItems.filter((_, index) => index !== itemIndex);
    } else {
      this.selectedItems.push(item);
    }

    this.unselectedItems = this.unselectedItems.filter(x => x.value !== item.value);

    this.renderSelectedItems();
    this.rerenderItems();
  }

  input() {
    const placeholder = this.selectedItems.length > 0 ? '' : this.element.dataset.placeholder;
    return this.element.dataset.selectAsInput.replace(/{{placeholder}}/g, placeholder);
  }

  updateInputOptions() {
    this.hiddenInputTarget.innerHTML = '';
    this.selectedItems.forEach(selected => {
      const option = document.createElement("option");
      option.text = selected.text;
      option.value = selected.value;
      option.setAttribute("selected", true);
      this.hiddenInputTarget.append(option);
    });

    this.hiddenInputTarget.value = this.selectedItems.map(item => item.value);
  }
}

export { Multiselect }
