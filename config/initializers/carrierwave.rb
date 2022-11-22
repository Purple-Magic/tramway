# frozen_string_literal: true

ActiveSupport.on_load :active_record do
  require 'audited'
end
