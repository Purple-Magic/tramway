# Tramway Grid

`tramway_grid` renders dashboard-style layouts made of fixed-size cells. It accepts `rows:` and `columns:` to define the
grid size.

Use `outline: true` when you want borders around the individual cells inside the grid. This makes the grid structure more
visible when the layout is sparse or when you want stronger cell separation. When `outline` is not enabled, the grid cells
render without visible internal borders.

Example:

```haml
= tramway_grid rows: 8, columns: 8, outline: true do
  = tramway_card size: [1, 2] do
    Revenue
```
