import { Controller } from "@hotwired/stimulus";

export default class TableRowPreview extends Controller {
  static targets = ["main"];

  connect() {
    this.items = JSON.parse(this.element.dataset.items || '{}');
  }

  toggle() {
    const rollUp = document.getElementById("roll-up");

    const titleText = document.createElement("h3");
    titleText.classList.add("text-xl");
    titleText.classList.add("dark:text-white");
    titleText.classList.add("py-4");
    titleText.classList.add("px-2");
    titleText.textContent = Object.values(this.items)[0];

    const existingTable = rollUp.querySelector(".div-table");
    if (existingTable) {
      existingTable.remove();
    }

    if (Object.keys(this.items).length === 0) return;

    const table = this.createTable(this.items);

    rollUp.insertAdjacentElement('afterbegin', table);
    rollUp.insertAdjacentElement('afterbegin', titleText);

    rollUp.classList.toggle("hidden");
  }

  createTable(items) {
    const table = document.createElement("div");
    table.classList.add("div-table");
    table.classList.add("dark:text-white");
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
    keyRow.classList.add("dark:bg-gray-700");
    keyRow.textContent = key;

    const valueRow = document.createElement("div"); 
    valueRow.classList.add("div-table-row");
    valueRow.classList.add("dark:bg-gray-800");
    valueRow.textContent = value;

    return [keyRow, valueRow];
  }
}

export { TableRowPreview };
