# frozen_string_literal: true

module TramwayHelpers::Buttons
  NEW_RECORD_BUTTON_SELECTOR = '.btn.btn-primary'
  EDIT_RECORD_BUTTON_SELECTOR = '.btn.btn-warning'

  def click_on_new_record
    find(NEW_RECORD_BUTTON_SELECTOR, match: :first).click
  end

  def click_on_submit
    click_on 'Save', class: 'btn-success'
  end

  def click_on_edit_record
    find(EDIT_RECORD_BUTTON_SELECTOR, match: :first).click
  end

  def click_on_delete_button(object)
    form = find destroy_record_button_selector object
    form.find('button[type="submit"]').click
  end

  def edit_path(object, redirect_to: nil)
    if redirect_to.present?
      association_path = Tramway::Engine.routes.url_helpers.record_path(
        object.public_send(redirect_to).id,
        model: object.public_send(redirect_to).class
      )
      edit_page_for object, redirect: association_path
    else
      edit_page_for object
    end
  end

  def delete_path(object)
    Tramway::Engine.routes.url_helpers.record_path(object.id, model: object.class)
  end

  def destroy_record_button_selector(object)
    "form[action='#{delete_path(object)}']"
  end

  def click_on_association_edit_button(object, redirect_to)
    find("a#{EDIT_RECORD_BUTTON_SELECTOR}[href='#{edit_path(object, redirect_to: redirect_to)}']").click
  end

  def click_on_association_delete_button(object)
    row = find("td[colspan='2'] td a[href='#{delete_path(object)}']").parent_node(level: 2)
    row.find('td button.delete[type="submit"]').click
  end
end

RSpec.configure do |config|
  config.include TramwayHelpers::Buttons
end
