# frozen_string_literal: true

module Tramway
  module ExtendableFormsHelpers
    module Validators
      def make_validates(property_name, validation, value)
        case validation[0].to_s
        when 'presence'
          presence_validator property_name, validation, value
        when 'inclusion'
          inclusion_validator property_name, validation, value
        end
      end

      def presence_validator(property_name, validation, value)
        validator_object = PresenceValidator.new(attributes: :not_blank)
        return if validation[1] == 'false'
        return if validation[1] == 'true' && validator_object.send(:valid?, value)

        model.errors.add(
          property_name,
          I18n.t(
            "activerecord.errors.models.#{model.class.name.underscore}.attributes.default.#{validation[0]}",
            value: value
          )
        )
      end

      def inclusion_validator(property_name, validation, value)
        in_array = validation[1][:in]

        return if value.in? in_array

        model.errors.add(
          property_name,
          I18n.t(
            "activerecord.errors.models.#{model.class.name.underscore}.attributes.default.#{validation[0]}",
            value: value
          )
        )
      end
    end
  end
end
