# frozen_string_literal: true

Tramway.configure do |config|
  config.pagination = { enabled: true }

  config.entities = [
    {
      name: :post,
      pages: [
        {
          action: :index,
          scope: :published
        },
        {
          action: :show
        }
      ]
    },
    {
      name: :comment,
      pages: [
        {
          action: :index
        }
      ]
    },
    {
      name: :article,
      pages: [
        {
          action: :index
        }
      ]
    },
    {
      name: :user
    }
  ]
end
