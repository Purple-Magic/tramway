# frozen_string_literal: true

module TramwayHelpers
  module Authorization
    def pass_authorization(user)
      visit home_page
      fill_in 'Email', with: user[:email]
      fill_in 'Password', with: '123'
      click_on 'Sign In', class: 'btn-success'
    end
  end
end

RSpec.configure do |config|
  config.include TramwayHelpers::Authorization
end
