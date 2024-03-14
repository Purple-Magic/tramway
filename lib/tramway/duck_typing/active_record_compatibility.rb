module Tramway
  module DuckTyping
    module ActiveRecordCompatibility
      %i[id model_name to_key errors to_param].each do |method_name|
        delegate method_name, to: :object
      end

      class << self
        def behave_as_ar
          %i[update destroy].each do |method_name|
            delegate method_name, to: :object
          end
        end
      end
    end
  end
end
