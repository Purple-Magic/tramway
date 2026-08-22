import { Controller } from "@hotwired/stimulus"
/* global console */

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
    const selectedValues = new Set(initialValues.map(value => value.toString()));
    const missingValues = initialValues
      .map(value => value.toString())
      .filter(value => !this.items.some(item => item.value.toString() === value));

    if (missingValues.length > 0) {
      console.warn(
        `Tramway select ignored ${missingValues.length} stale selected value${missingValues.length === 1 ? '' : 's'} ` +
        `that are not present in the collection: ${missingValues.join(', ')}.`
      );
    }

    this.items.forEach(item => {
      item.selected = selectedValues.has(item.value.toString());
    });

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

    if (itemIndex === -1) {
      return;
    }

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
    this.syncBoxStyle(checked)
    this.buttonTarget.classList.toggle("border-zinc-50", checked)
    this.buttonTarget.classList.toggle("border-zinc-800", !checked)
    this.buttonTarget.classList.toggle("bg-zinc-50", checked)
    this.buttonTarget.classList.toggle("text-zinc-950", checked)
    this.buttonTarget.classList.toggle("bg-zinc-950", !checked)
    this.buttonTarget.classList.toggle("text-zinc-50", !checked)
    this.indicatorTarget.classList.toggle("hidden", !checked)
    this.buttonTarget.toggleAttribute("disabled", this.inputTarget.disabled)
  }

  syncBoxStyle(checked) {
    const size = this.checkboxSize()

    this.buttonTarget.style.width = size
    this.buttonTarget.style.height = size
    this.buttonTarget.style.minWidth = size
    this.buttonTarget.style.minHeight = size
    this.buttonTarget.style.display = "inline-flex"
    this.buttonTarget.style.alignItems = "center"
    this.buttonTarget.style.justifyContent = "center"
    this.buttonTarget.style.padding = "0"
    this.buttonTarget.style.lineHeight = "1"
    this.buttonTarget.style.boxSizing = "border-box"
    this.buttonTarget.style.backgroundColor = checked ? "#fafafa" : "#09090b"
    this.buttonTarget.style.color = checked ? "#09090b" : "#fafafa"
  }

  checkboxSize() {
    if (this.buttonTarget.classList.contains("h-4")) return "1rem"
    if (this.buttonTarget.classList.contains("h-6")) return "1.5rem"

    return "1.25rem"
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

class Navbar extends Controller {
  connect() {
    this.root = document.documentElement
    this.desktopBreakpoint = 768
    this.menuHiddenClass = 'hidden'
    this.menuOffscreenClass = '-translate-x-full'
    this.rootLockClass = 'overflow-hidden'
    this.desktopNavbarExpandedWidthClass = 'md:w-72'
    this.desktopNavbarCollapsedWidthClass = 'md:w-24'
    this.desktopMainExpandedPaddingClass = 'md:pl-72'
    this.desktopMainCollapsedPaddingClass = 'md:pl-24'
    this.hiddenInteractionClasses = ['opacity-0', 'pointer-events-none']

    this.desktopNavbar = this.element
    this.desktopHeader = document.getElementById('desktop-navbar-header')
    this.desktopMenu = document.getElementById('desktop-navbar-content')
    this.desktopMainContainer = document.getElementById('tramway-main-container')
    this.desktopToggleButton = document.getElementById('desktop-navbar-toggle-button')
    this.desktopToggleIcon = document.getElementById('desktop-navbar-toggle-icon')
    this.desktopToggleWrapper = document.getElementById('desktop-navbar-toggle-wrapper')
    this.mobileButton = document.getElementById('mobile-menu-button')
    this.mobileCloseButton = document.getElementById('mobile-menu-close-button')
    this.mobileMenu = document.getElementById('mobile-menu')

    this.handleMobileToggle = this.toggleMobileMenu.bind(this)
    this.handleMobileClose = this.closeMobileMenu.bind(this)
    this.handleBeforeCache = this.handleBeforeCache.bind(this)
    this.handleResize = this.handleResize.bind(this)
    this.handleDesktopToggle = this.toggleDesktopExpanded.bind(this)

    this.bindMobileControls()
    this.bindDesktopControls()
    document.addEventListener('turbo:before-cache', this.handleBeforeCache)
    window.addEventListener('resize', this.handleResize)

    if (this.isDesktopViewport()) {
      this.syncDesktopExpandedState()
    }
  }

  disconnect() {
    document.removeEventListener('turbo:before-cache', this.handleBeforeCache)
    window.removeEventListener('resize', this.handleResize)
  }

  bindMobileControls() {
    if (this.mobileButton) {
      this.mobileButton.addEventListener('click', this.handleMobileToggle)
    }

    if (this.mobileCloseButton) {
      this.mobileCloseButton.addEventListener('click', this.handleMobileClose)
    }

    if (this.mobileMenu) {
      this.mobileMenu.querySelectorAll('a').forEach((link) => {
        link.addEventListener('click', () => this.closeMobileMenu())
      })
    }
  }

  bindDesktopControls() {
    if (this.isVertical() && this.desktopToggleButton) {
      this.desktopToggleButton.addEventListener('click', this.handleDesktopToggle)
    }
  }

  handleBeforeCache() {
    this.closeMobileMenu({ hideImmediately: true })
  }

  handleResize() {
    if (window.innerWidth >= 640) {
      this.closeMobileMenu({ hideImmediately: true })
    }

    if (this.isDesktopViewport()) {
      this.syncDesktopExpandedState()
    }
  }

  toggleMobileMenu() {
    if (!this.mobileMenu) return

    if (this.mobileMenu.classList.contains(this.menuHiddenClass)) {
      this.openMobileMenu()
      return
    }

    this.closeMobileMenu()
  }

  openMobileMenu() {
    if (!this.mobileMenu) return

    this.mobileMenu.classList.remove(this.menuHiddenClass)
    window.requestAnimationFrame(() => {
      this.mobileMenu.classList.remove(this.menuOffscreenClass)
      this.root.classList.add(this.rootLockClass)
    })
  }

  closeMobileMenu({ hideImmediately = false } = {}) {
    if (!this.mobileMenu) {
      this.root.classList.remove(this.rootLockClass)
      return
    }

    this.mobileMenu.classList.add(this.menuOffscreenClass)
    this.root.classList.remove(this.rootLockClass)

    if (hideImmediately) {
      this.mobileMenu.classList.add(this.menuHiddenClass)
      return
    }

    this.mobileMenu.addEventListener(
      'transitionend',
      () => this.mobileMenu.classList.add(this.menuHiddenClass),
      { once: true }
    )
  }

  toggleDesktopExpanded() {
    this.setDesktopExpanded(this.desktopNavbar.dataset.expanded === 'false')
  }

  syncDesktopExpandedState() {
    this.setDesktopExpanded(this.desktopNavbar.dataset.expanded !== 'false')
  }

  setDesktopExpanded(expanded) {
    if (!this.isVertical() || !this.desktopNavbar || !this.desktopHeader || !this.desktopMenu || !this.desktopMainContainer || !this.desktopToggleButton || !this.desktopToggleWrapper) {
      return
    }

    this.desktopNavbar.classList.toggle(this.desktopNavbarExpandedWidthClass, expanded)
    this.desktopNavbar.classList.toggle(this.desktopNavbarCollapsedWidthClass, !expanded)
    this.desktopNavbar.dataset.expanded = expanded ? 'true' : 'false'

    this.desktopMainContainer.classList.toggle(this.desktopMainExpandedPaddingClass, expanded)
    this.desktopMainContainer.classList.toggle(this.desktopMainCollapsedPaddingClass, !expanded)

    this.hiddenInteractionClasses.forEach((className) => {
      this.desktopHeader.classList.toggle(className, !expanded)
      this.desktopMenu.classList.toggle(className, !expanded)
    })

    this.desktopHeader.toggleAttribute('inert', !expanded)
    this.desktopMenu.toggleAttribute('inert', !expanded)
    this.desktopHeader.setAttribute('aria-hidden', expanded ? 'false' : 'true')
    this.desktopMenu.setAttribute('aria-hidden', expanded ? 'false' : 'true')

    this.desktopToggleWrapper.classList.toggle('justify-end', expanded)
    this.desktopToggleWrapper.classList.toggle('justify-center', !expanded)
    if (this.desktopToggleIcon) {
      this.desktopToggleIcon.className = expanded ? 'fa fa-chevron-left' : 'fa fa-chevron-right'
    }

    this.desktopToggleButton.setAttribute('aria-label', expanded ? 'Collapse sidebar' : 'Expand sidebar')

    this.desktopToggleButton.setAttribute('aria-expanded', expanded ? 'true' : 'false')
  }

  isVertical() {
    return this.element.dataset.direction === 'vertical'
  }

  isDesktopViewport() {
    return this.isVertical() && window.innerWidth >= this.desktopBreakpoint
  }
}

export { TramwaySelect, TableRowPreview, UiCheckbox, Tooltip, Navbar }
