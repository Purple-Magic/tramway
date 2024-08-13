import { Controller } from "@hotwired/stimulus"

export default class Multiselect extends Controller {
  static targets = ["dropdown", "showSelectedArea"];

  static values = {
    items: Array,
    dropdownContainer: String,
    itemContainer: String,
    selectedItemTemplate: String,
    dropdownState: String,
    selectedItems: Array,
    placeholder: String
  }

  connect() {
    this.dropdownState = 'closed';
    this.unselectedItems = JSON.parse(this.element.dataset.items);
    this.selectedItems = [];
    this.renderSelectedItems()
  }

  renderSelectedItems() {
    const allItems = this.fillTemplate(this.element.dataset.selectedItemTemplate, this.selectedItems)

    this.showSelectedAreaTarget.innerHTML = allItems
    this.showSelectedAreaTarget.insertAdjacentHTML(
      "beforeEnd",
      inputHTML(this.selectedItems, this.element.dataset.placeholder)
    )
  }

  fillTemplate(template, items) {
    return items.map((item) => {
      return template.replace(/{{text}}/g, item.text).replace(/{{value}}/g, item.value)
    }).join('')
  }

  closeOnClickOutside() {
    if (this.dropdownState === 'open' && !this.element.contains(event.target)) {
      this.closeDropdown()
    }
  }

  toggleDropdown() {
    if (this.dropdownState === 'closed') {
      this.openDropdown()
    } else {
      this.closeDropdown()
    }
  }

  rerenderItems() {
    this.closeDropdown();
    this.openDropdown();
  }

  openDropdown() {
    this.dropdownState = 'open';
    this.dropdownTarget.insertAdjacentHTML("afterend", this.template)

    if (dropdown()) {
      dropdownElement.addEventListener('click', event => event.stopPropagation());
    }
  }

  dropdown() {
    this.element.querySelector('#dropdown')
  }

  closeDropdown() {
    this.dropdownState = 'closed';
    if (dropdown()) {
      this.element.querySelector('#dropdown').remove();
    }
  }

  get template() {
    return this.element.dataset.dropdownContainer.replace(
      /{{content}}/g,
      this.fillTemplate(this.element.dataset.itemContainer, this.unselectedItems)
    )
  }

  toggleItem({ currentTarget }) {
    const item = {
      text: currentTarget.dataset.text,
      value: currentTarget.dataset.value
    }

    const itemIndex = this.selectedItems.findIndex(x => x.value.toString() === item.value);
    if (itemIndex !== -1) {
      this.selectedItems = [...this.selectedItems.slice(0, itemIndex), ...this.selectedItems.slice(itemIndex + 1)];
    } else {
      this.selectedItems = [...this.selectedItems, item];
    }

    const unselectedItemIndex = this.unselectedItems.findIndex(x => x.value.toString() === item.value);
    if (unselectedItemIndex !== -1) {
      this.unselectedItems = [
        ...this.unselectedItems.slice(0, unselectedItemIndex),
        ...this.unselectedItems.slice(unselectedItemIndex + 1)
      ];
    }

    this.renderSelectedItems()
    this.rerenderItems()
  }
}

const inputHTML = (selectedItems, placeholder) => {
  return `
  <div class="flex-1">
  <input class="bg-transparent p-1 px-2 appearance-none outline-none h-full w-full text-gray-800" multiple="multiple" placeholder="${selectedItems.length > 0 ? '' : placeholder}">
  </div>
  `
}

export { Multiselect }
