import { Controller } from "@hotwired/stimulus"

class TramwaySelect extends Controller {
  static targets = ["dropdown", "showSelectedArea", "hiddenInput", "caretDown", "caretUp"]

  static values = {
    items: Array,
    dropdownContainer: String,
    itemContainer: String,
    selectedItemTemplate: String,
    dropdownState: String,
    selectedItems: Array,
    placeholder: String,
    selectAsInput: String,
    value: Array,
    onChange: String,
    multiple: Boolean,
    autocomplete: Boolean,
    autocompleteInput: String
  }

  connect() {
    this.dropdownState = 'closed';

    this.items = JSON.parse(this.element.dataset.items).map((item, index) => {
      return {
        index,
        text: item.text,
        value: item.value.toString(),
        selected: false
      }
    });

    const initialValues = this.element.dataset.value === undefined ? [] : JSON.parse(this.element.dataset.value);

    initialValues.map((value) => {
      const itemIndex = this.items.findIndex(x => x.value.toString() === value.toString());
      this.items[itemIndex].selected = true;
    })

    this.selectedItems = this.items.filter(item => item.selected);

    this.renderSelectedItems();
  }

  renderSelectedItems() {
    const allItems = this.fillTemplate(this.element.dataset.selectedItemTemplate, this.selectedItems)

    let content = allItems;

    if (this.autocomplete() && this.selectedItems.length === 0) {
      content += this.element.dataset.autocompleteInput;
    }

    this.showSelectedAreaTarget.innerHTML = content;
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

    this.caretDownTarget.classList.add('hidden');
    this.caretUpTarget.classList.remove('hidden');
  }

  dropdown() {
    return this.element.querySelector('#dropdown');
  }

  closeDropdown() {
    this.dropdownState = 'closed';

    if (this.dropdown()) {
      this.dropdown().remove();
    }

    const onChange = this.element.dataset.onChange;

    if (onChange) {
      const [controllerName, actionName] = onChange.split('#');
      const controller = this.application.controllers.find(controller => controller.identifier === controllerName)

      if (controller) {
        if (typeof controller[actionName] === 'function') {
          controller[actionName]({ target: this.element });
        } else {
          alert(`Action not found: ${actionName}`); // eslint-disable-line no-undef
        }
      } else {
        alert(`Controller not found: ${controllerName}`); // eslint-disable-line no-undef
      }
    }

    this.caretDownTarget.classList.remove('hidden');
    this.caretUpTarget.classList.add('hidden');
  }

  get template() {
    return this.element.dataset.dropdownContainer.replace(
      /{{content}}/g,
      this.fillTemplate(this.element.dataset.itemContainer, this.items.filter(item => !item.selected))
    );
  }

  toggleItem({ currentTarget }) {
    const itemIndex = this.items.findIndex(x => x.value === currentTarget.dataset.value);
    const itemSelectedIndex = this.selectedItems.findIndex(x => x.value === currentTarget.dataset.value);

    if (!this.multiple()) {
      this.selectedItems = [];
      this.items.forEach(item => item.selected = false);
      this.closeDropdown()
    }

    if (itemSelectedIndex !== -1) {
      this.selectedItems = this.selectedItems.filter((_, index) => index !== itemSelectedIndex);
      this.items[itemIndex].selected = false;
    } else {
      this.selectedItems.push(this.items[itemIndex]);
      this.items[itemIndex].selected = true;
    }

    this.renderSelectedItems();

    if (this.multiple()) {
      this.rerenderItems();
    }
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

  multiple() {
    return this.element.dataset.multiple == 'true';
  }

  autocomplete() {
    return this.element.dataset.autocomplete == 'true';
  }

  search(event) {
    const searchTerm = event.target.value.toLowerCase();
    const filteredItems = this.items.filter(item => item.text.toLowerCase().includes(searchTerm) && !item.selected);
    const dropdown = this.dropdown();

    if (dropdown) {
      dropdown.innerHTML = this.fillTemplate(this.element.dataset.itemContainer, filteredItems);
    }
  }
}

class TableRowPreview extends Controller {
  connect() {
    this.items = JSON.parse(this.element.dataset.items || '{}');
    this.attachSwipeGesture();
  }

  disconnect() {
    this.detachSwipeGesture();
  }

  toggle() {
    const rollUp = this.rollUpElement();
    if (!rollUp) return;

    rollUp.classList.remove("animate-roll-down");
    rollUp.classList.add("animate-roll-up");

    if (Object.keys(this.items).length === 0) {
      rollUp.classList.remove("hidden");
      return;
    }

    const existingTable = rollUp.querySelector(".div-table");
    if (existingTable) {
      existingTable.remove();
    }

    const existingTitle = rollUp.querySelector("h3");
    if (existingTitle) {
      existingTitle.remove();
    }

    const titleText = document.createElement("h3");

    titleText.classList.add("text-xl");
    titleText.classList.add("text-white");
    titleText.classList.add("py-4");
    titleText.classList.add("px-4");
    titleText.textContent = Object.values(this.items)[0];

    const table = this.createTable(this.items);

    rollUp.insertAdjacentElement('afterbegin', table);
    rollUp.insertAdjacentElement('afterbegin', titleText);

    rollUp.classList.remove("hidden");
  }

  close() {
    const rollUp = this.rollUpElement();
    if (!rollUp) return;

    this.resetDragStyles(rollUp);
    rollUp.classList.remove("animate-roll-up");
    rollUp.classList.add("animate-roll-down");

    rollUp.addEventListener("animationend", () => {
      rollUp.classList.add("hidden");
      rollUp.classList.remove("animate-roll-down");
      rollUp.classList.add("animate-roll-up");
    }, { once: true });
  }

  rollUpElement() {
    if (this.element.id === "roll-up") return this.element;

    return this.element.previousElementSibling || document.getElementById("roll-up");
  }

  attachSwipeGesture() {
    if (this.element.id !== "roll-up") return;

    this.startY = null;
    this.startX = null;
    this.currentDeltaY = 0;

    this.onTouchStart = (event) => {
      if (this.element.classList.contains("hidden")) return;
      if (event.touches.length !== 1) return;

      this.startY = event.touches[0].clientY;
      this.startX = event.touches[0].clientX;
      this.currentDeltaY = 0;
      this.element.style.transition = "none";
    };

    this.onTouchMove = (event) => {
      if (this.startY === null || event.touches.length !== 1) return;

      const deltaY = event.touches[0].clientY - this.startY;
      const deltaX = Math.abs(event.touches[0].clientX - this.startX);
      if (deltaY <= 0 || deltaY <= deltaX) return;

      this.currentDeltaY = deltaY;
      this.element.style.transform = `translateY(${deltaY}px)`;
      event.preventDefault();
    };

    this.onTouchEnd = () => {
      if (this.startY === null) return;

      const shouldClose = this.currentDeltaY > 80;
      this.startY = null;
      this.startX = null;

      if (shouldClose) {
        this.close();
        return;
      }

      this.resetDragStyles(this.element);
    };

    this.element.addEventListener("touchstart", this.onTouchStart, { passive: true });
    this.element.addEventListener("touchmove", this.onTouchMove, { passive: false });
    this.element.addEventListener("touchend", this.onTouchEnd);
    this.element.addEventListener("touchcancel", this.onTouchEnd);
  }

  detachSwipeGesture() {
    if (this.element.id !== "roll-up") return;
    if (!this.onTouchStart) return;

    this.element.removeEventListener("touchstart", this.onTouchStart);
    this.element.removeEventListener("touchmove", this.onTouchMove);
    this.element.removeEventListener("touchend", this.onTouchEnd);
    this.element.removeEventListener("touchcancel", this.onTouchEnd);
  }

  resetDragStyles(element) {
    element.style.transition = "";
    element.style.transform = "";
  }

  createTable(items) {
    const table = document.createElement("div");
    table.classList.add("div-table");
    table.classList.add("text-white");
    table.classList.add("px-2");

    Object.entries(items).forEach(([key, value]) => {
      const rows = this.createTableRow(key, value);

      rows.forEach((row) => table.appendChild(row));
    });

    return table;
  }

  createTableRow(key, value) {
    const keyRow = document.createElement("div");
    keyRow.classList.add("div-table-row");
    keyRow.classList.add("bg-gray-700");
    keyRow.classList.add("text-white");
    keyRow.classList.add("px-2");
    keyRow.classList.add("py-1");
    keyRow.classList.add("text-xs");
    keyRow.classList.add("font-semibold");
    keyRow.textContent = key;

    const valueRow = document.createElement("div");
    valueRow.classList.add("div-table-row");
    valueRow.classList.add("bg-gray-800");
    valueRow.classList.add("px-2");
    valueRow.classList.add("py-2");
    valueRow.textContent = value;

    return [keyRow, valueRow];
  }
}

class UiCheckbox extends Controller {
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

class Tooltip extends Controller {
  static targets = ["panel"]

  toggle(event) {
    event.stopPropagation()

    this.panelTarget.classList.toggle("hidden")
  }

  closeOnClickOutside(event) {
    if (this.element.contains(event.target)) return

    this.panelTarget.classList.add("hidden")
  }
}

export { TramwaySelect, TableRowPreview, UiCheckbox, Tooltip }
