# Tramway Navbar

`tramway_navbar` renders the app navigation, either as a classic top bar (`direction: :horizontal`) or as a
collapsible left sidebar (`direction: :vertical`, the default).

```haml
= tramway_navbar title: 'Purple Magic' do |nav|
  - nav.left do
    - nav.item 'Users', users_path
  - nav.right do
    - nav.item 'Sign out', sign_out_path, method: :delete
```

See the [main README's Tramway Navbar section](https://github.com/Purple-Magic/tramway#tramway-navbar) for the full
list of options (`title`, `title_link`, `direction`, `background`, `with_entities`).

## Collapsed/expanded state persists across pages

On desktop, the vertical sidebar has a toggle button that collapses it down to an icon-only rail. That
collapsed/expanded choice is remembered per browser: collapsing the sidebar on one page keeps it collapsed on every
other page until it's expanded again.

- The state is stored in the browser's `localStorage` under the key `tramway-navbar-expanded` (`"true"` or
  `"false"`), written by the `tramway-navbar` Stimulus controller whenever the toggle button is used.
- It is per-browser, not per-user: it isn't synced across devices and isn't stored server-side.
- If `localStorage` is unavailable (e.g. private browsing with storage blocked), the sidebar just always starts
  expanded — nothing breaks, the preference simply isn't remembered.

### Why there's no flash of the wrong state

The server has no way to know the browser's stored preference, so it always renders the sidebar expanded. Normally
that would mean the sidebar visibly flashes expanded and then snaps to collapsed once the Stimulus controller
connects and JavaScript finishes loading — noticeable, since collapsing changes both the sidebar's width and the
main content's left padding.

To avoid that, `tramway_navbar` renders a small blocking inline `<script>` alongside its markup (right after the
`<nav>`/mobile-menu markup, before the component's `<style>` block). It runs synchronously as the page is parsed,
before the browser paints anything, and — if the stored preference is
`"false"` — sets `data-tramway-navbar-expanded="false"` on the `<html>` element. A matching CSS rule (scoped to
`@media (min-width: 768px)`, shipped alongside the navbar's other styles) reacts to that attribute and applies the
collapsed width, main-container padding, and faded header/menu right away, well before any JavaScript module has
had a chance to run. The Stimulus controller then keeps this `<html>` attribute in sync going forward (on connect
and on every toggle), so the pre-paint CSS and the controller's own classes always agree and never fight each
other.

In short: the collapsed state is visually correct from the very first paint, with no flicker.
