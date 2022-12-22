# frozen_string_literal: true

module Tramway
  class User < ::Tramway::ApplicationRecord
    has_secure_password

    if defined? Tramway::Conference
      has_many :social_networks, as: :record,
                                 class_name: 'Tramway::Profiles::SocialNetwork'
    end

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
end
