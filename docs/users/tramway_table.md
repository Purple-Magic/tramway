# Tramway Table

See the [main README's Tramway Table Component section](https://github.com/Purple-Magic/tramway#tramway-table-component)
for the basic usage of `tramway_table`, `tramway_row`, `tramway_header`, and `tramway_cell`.

## Mobile behavior: horizontal scroll instead of hidden columns

On narrow screens the table does not hide any columns. All columns always render, and the table wraps in a
horizontal scroll container (`overflow-x-auto`, with a persistent, always-visible scrollbar) so you can swipe/scroll
left-to-right to see columns that don't fit the viewport.

This is CSS-only: each column has a minimum width (based on the table's `size:`), so the grid naturally overflows
its container on small screens instead of shrinking or hiding cells. Each row and the header grow to that same
overflowed width (instead of clipping at the container edge), so the header background and borders stay aligned
with the columns as you scroll.

The previous mobile "tap row to preview" slide-up panel (and the `preview:` option on `tramway_row`) has been
removed, since it is no longer needed once every column is reachable via horizontal scroll.

## The scroll stays inside the table, not the whole page

The table's own scroll container is capped to the width of the page (`w-full max-w-full min-w-0`), and
`Tramway::Containers::NarrowComponent` (the default page container wrapping entity index/show pages) uses the same
`w-full max-w-full min-w-0` sizing instead of `w-max`. This keeps a wide table's horizontal overflow contained to
the table itself — the page no longer stretches past the viewport width on mobile when a table's columns are wider
than the screen.

On the entities index page, the pagination controls and the "page X of Y" hint (`page_entries_info`) render outside
of `tramway_table`, below the scroll container, so they stay put and visible regardless of how far the table is
scrolled horizontally.
