import { Controller } from "@hotwired/stimulus";

export default class TableRowPreview extends Controller {
  connect() {
    this.items = JSON.parse(this.element.dataset.items || '{}');
  }

  toggle() {
    const rollUp = document.getElementById("roll-up");

    const existingTable = rollUp.querySelector(".div-table");
    if (existingTable) {
      existingTable.remove();
    }

    const existingTitle = rollUp.querySelector("h3");
    if (existingTitle) {
      existingTitle.remove();
    }

    if (Object.keys(this.items).length === 0) return;

    const titleText = document.createElement("h3");

    titleText.classList.add("text-xl");
    titleText.classList.add("text-white");
    titleText.classList.add("py-4");
    titleText.classList.add("px-4");
    titleText.textContent = Object.values(this.items)[0];

    const table = this.createTable(this.items);

    rollUp.insertAdjacentElement('afterbegin', table);
    rollUp.insertAdjacentElement('afterbegin', titleText);

    rollUp.classList.toggle("hidden");
  }

  close() {
    const rollUp = document.getElementById("roll-up");
    rollUp.classList.add("hidden");
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
