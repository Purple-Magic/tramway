# frozen_string_literal: true

Ckeditor.setup do |config|
  require 'ckeditor/orm/active_record'

  config.assets_plugins = %w[image copyformatting filebrowser sourcedialog]
end
