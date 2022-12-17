# frozen_string_literal: true

class TestModel < ApplicationRecord
  has_many :association_models, class_name: 'AssociationModel'
  has_many :another_association_models

  enumerize :enumerized, in: %i[first second], default: :first
end
