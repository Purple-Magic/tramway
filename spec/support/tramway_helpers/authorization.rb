# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
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
# rubocop:enable Style/ClassAndModuleChildren

RSpec.configure do |config|
  config.include TramwayHelpers::Authorization
end
