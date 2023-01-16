# frozen_string_literal: true

module NavbarHelper
  def click_on_dropdown(text)
    first('ul.navbar-nav li.nav-item.dropdown a.nav-link.dropdown-toggle', text: text, visible: true).click
  end
end
