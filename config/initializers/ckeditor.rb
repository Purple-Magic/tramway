# frozen_string_literal: true

require 'ckeditor'

Ckeditor.setup do |config|
  require 'ckeditor/orm/active_record'

  config.assets_plugins = %w[image copyformatting filebrowser sourcedialog]
end
