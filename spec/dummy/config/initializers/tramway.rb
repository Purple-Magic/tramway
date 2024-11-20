# frozen_string_literal: true

Tramway.configure do |config|
  config.pagination = { enabled: true }

  config.entities = [
    {
      name: :post,
      pages: [:index]
    },
    {
      name: :comment,
      pages: [:index]
    },
    {
      name: :user
    }
  ]
end
