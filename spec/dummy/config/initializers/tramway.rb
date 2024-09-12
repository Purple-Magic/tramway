# frozen_string_literal: true

Tramway.configure do |config|
  config.pagination = { enabled: true }

  config.entities = [:user, :post]
end
