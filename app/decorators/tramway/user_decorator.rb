# frozen_string_literal: true

class Tramway::UserDecorator < Tramway::ApplicationDecorator
  class << self
    def collections
      [:all]
    end

    def list_attributes
      [:email]
    end

    def show_attributes
      %i[email first_name last_name phone role created_at updated_at credential_text]
    end

    if defined? Tramway::Conference
      def show_associations
        [:social_networks]
      end
    end
  end

  decorate_association :social_networks, as: :record if defined? Tramway::Conference

  delegate_attributes :first_name, :last_name, :email, :phone, :role, :created_at, :updated_at, :admin?

  def name
    "#{object&.first_name} #{object&.last_name}"
  end

  def credential_text
    content_tag(:pre) do
      id = "credential_text_#{object.id}"

      concat(content_tag(:span, id:) do
        text = "URL: #{ENV['PROJECT_URL']}\n"
        text += "Email: #{object.email}\n"
        "#{text}Password: "
      end)

      concat(content_tag(:br))

      concat copy_to_clipboard id
    end
  end

  alias title name
end
