module TramwayHelpers::Buttons
  def click_on_new_record
    find('.btn.btn-primary', match: :first).click
  end

  def click_on_submit
    click_on 'Save', class: 'btn-success'
  end
end

RSpec.configure do |config|
  config.include TramwayHelpers::Buttons
end
