# frozen_string_literal: true

module TramwayHelpers
  def click_on_association_delete_button(object)
    delete_path = ::Tramway::Engine.routes.url_helpers.record_path(
      object.id,
      model: object.class
    )
    row = find("td[colspan='2'] td a[href='#{delete_path}']").parent_node(level: 2)
    row.find('td button.delete[type="submit"]').click
  end

  def click_on_tab(text)
    find('li.nav-item a.nav-link', text:).click
  end

  def click_on_table_item(text)
    find('table td a', text:).click
  end

  def click_on_delete_button(object)
    delete_path = ::Tramway::Engine.routes.url_helpers.record_path(
      object.id,
      model: object.class
    )
    form = find("form[action='#{delete_path}']")
    form.find('button[type="submit"]').click
  end

  def fill_in_ckeditor(name, with:)
    id = name.gsub(']', '').split('[').join('_')
    content = with.to_json # convert to a safe javascript string
    page.execute_script <<-SCRIPT
      CKEDITOR.instances['#{id}'].setData(#{content});
      $('textarea##{id}').text(#{content});
    SCRIPT
  end

  def fill_in_datepicker(name, with:)
    return unless with.present?

    input = find("input[name=#{name.gsub('[', '\[').gsub(']', '\]')}]")
    input.click

    find('td.day', text: /^#{with.day}$/, match: :first).click
  end
end
