# frozen_string_literal: true

require 'carrierwave'

class ApplicationUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "system/uploads/#{model.class.model_name.to_s.underscore}/#{mounted_as}/#{id_directory}"
  end

  private

  def id_directory
    if model.respond_to?(:uuid)
      model.reload unless model.uuid.present?
      model.uuid
    else
      model.id
    end
  end
end
