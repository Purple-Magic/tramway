# frozen_string_literal: true

class Tramway::User < Tramway::ApplicationRecord
  has_secure_password

  scope :admins, -> { where role: :admin }
  scope :simple_users, -> { where role: :user }

  enumerize :role, in: %i[user admin], default: :admin

  def admin?
    role.admin?
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
