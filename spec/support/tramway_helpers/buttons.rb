module TramwayHelpers::Buttons
  def click_on_new_record
    find('.btn.btn-primary', match: :first).click
  end

  def click_on_submit
    click_on 'Save', class: 'btn-success'
  end

  def click_on_edit_record
    find('.btn.btn-warning', match: :first).click
  end

  def click_on_delete_button(object)
    delete_path = ::Tramway::Engine.routes.url_helpers.record_path(object.id, model: object.class)

    form = find("form[action='#{delete_path}']")
    form.find('button[type="submit"]').click
  end
end

RSpec.configure do |config|
  config.include TramwayHelpers::Buttons
end
