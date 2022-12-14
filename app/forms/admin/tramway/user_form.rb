# frozen_string_literal: true

class Admin::Tramway::UserForm < ::Tramway::ApplicationForm
  self.model_class = Tramway::User

  properties :email, :password, :first_name, :last_name, :role, :phone

  # fix me
  validates :email, email: true, uniqueness: true, on: :destroy unless model_class.columns_hash['project_id'].present?

  def initialize(object)
    super(object).tap do
      form_properties email: :string,
                      password: :string,
                      first_name: :string,
                      last_name: :string,
                      phone: :string,
                      role: :default
    end
  end
end
