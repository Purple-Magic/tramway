# frozen_string_literal: true

Rails.application.config.assets.precompile += [
  'vendor/assets/javascripts/*',
  'vendor/assets/stylesheets/*',
  'tramway/admin/ckeditor/*'
]
