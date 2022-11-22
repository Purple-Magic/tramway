# frozen_string_literal: true

class Tramway::User::User < ::Tramway::ApplicationRecord
  has_secure_password # FIXME: remove repeating from tramway-user
  include ::AASM

  enumerize :role, in: %i[user admin], default: :admin

  def admin?
    role.admin?
  end

  scope :admins, -> { where role: :admin }
  scope :simple_users, -> { where role: :user }
end
