module TramwayHelpers::Buttons
  def click_on_new_record
    find('.btn.btn-primary', match: :first).click
  end
end

RSpec.configure do |config|
  config.include TramwayHelpers::Buttons
end
