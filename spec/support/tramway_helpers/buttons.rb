# frozen_string_literal: true

module TramwayHelpers::Buttons
  NEW_RECORD_BUTTON_SELECTOR = '.btn.btn-primary'

  def click_on_new_record
    find(NEW_RECORD_BUTTON_SELECTOR, match: :first).click
  end

  def click_on_submit
    click_on 'Save', class: 'btn-success'
  end

  def click_on_edit_record
    find('.btn.btn-warning', match: :first).click
  end

  def click_on_delete_button(object)
    form = find destroy_record_button_selector object
    form.find('button[type="submit"]').click
  end

  def delete_path(object)
    Tramway::Engine.routes.url_helpers.record_path(object.id, model: object.class)
  end

  def destroy_record_button_selector(object)
    "form[action='#{delete_path(object)}']"
  end
end

RSpec.configure do |config|
  config.include TramwayHelpers::Buttons
end
