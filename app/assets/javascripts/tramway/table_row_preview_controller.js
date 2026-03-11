import { Controller } from "@hotwired/stimulus";

export default class TableRowPreview extends Controller {
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

    // Show pre-rendered preview content that is hidden by default.
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

export { TableRowPreview };
