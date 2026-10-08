# frozen_string_literal: true

Tramway.configure do |config|
  config.entities = [
    {
      name: :post,
      namespace: :admin,
      pages: [
        {
          action: :index,
          scope: :published,
          search: true,
          includes: [:user]
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
        },
        {
          action: :stats
        },
        {
          action: :export,
          member: true,
          via: %i[get post],
          params: [:kind]
        }
      ]
    },
    {
      name: :comment,
      namespace: :admin,
      pages: [
        {
          action: :index,
          filters: %i[with_text without_text]
        }
      ]
    },
    {
      name: :article,
      namespace: :admin,
      pages: [
        {
          action: :index,
          search: true
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

  config.plugins = [:solid_queue]
  config.plugins.solid_queue = {
    path: '/jobs'
  }
end
