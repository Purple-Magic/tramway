# frozen_string_literal: true

Tramway.configure do |config|
  config.pagination = { enabled: true }

  config.entities = [
    {
      name: :post,
      namespace: :admin,
      pages: [
        {
          action: :index,
          scope: :published
        },
        {
          action: :show
        },
        {
          action: :create
        },
        {
          action: :update
        },
        {
          action: :destroy
        }
      ]
    },
    {
      name: :comment,
      namespace: :admin,
      pages: [
        {
          action: :index
        }
      ]
    },
    {
      name: :article,
      namespace: :admin,
      pages: [
        {
          action: :index
        }
      ]
    },
    {
      name: :user
    },
    {
      name: :like,
      namespace: :admin,
      pages: [
        {
          action: :index
        }
      ]
    }
  ]
end
