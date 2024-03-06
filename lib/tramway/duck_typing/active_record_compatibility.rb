module Tramway
  module DuckTyping
    module ActiveRecordCompatibility
      def to_param
        id.to_s
      end
    end
  end
end

Tramway::BaseDecorator.include Tramway::DuckTyping::ActiveRecordCompatibility
Tramway::BaseForm.include Tramway::DuckTyping::ActiveRecordCompatibility
