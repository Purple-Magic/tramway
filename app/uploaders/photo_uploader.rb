# frozen_string_literal: true

class PhotoUploader < ApplicationUploader
  include ImageDefaults

  def default_url
    ActionController::Base.helpers.asset_path('mona_lisa_from_prado_square.png')
  end

  def url
    if file.present? && File.exist?(file.file)
      file.file.match(%r{/system/uploads/.*}).to_s
    else
      default_url = '/assets/tramway/core/mona_lisa_from_prado_square.jpg'
      File.exist?(default_url) ? default_url : ''
    end
  end

  version :medium, if: :medium_version_is_needed? do
    process resize_to_fill: [400, 400]
  end

  version :small, if: :small_version_is_needed? do
    process resize_to_fill: [100, 100]
  end

  attr_reader :width, :height

  before :cache, :capture_size

  def capture_size(file)
    return unless version_name.blank?

    if file.path.nil?
      img = ::MiniMagick::Image.read(file.file)
      @width = img[:width]
      @height = img[:height]
    else
      @width, @height = `identify -format "%wx %h" #{file.path}`.split(/x/).map(&:to_i)
    end
  end

  def medium_version_is_needed?(_new_file)
    version_is_needed? :medium
  end

  def small_version_is_needed?(_new_file)
    version_is_needed? :small
  end

  def version_is_needed?(version)
    model.class.photo_versions&.include? version
  end
end
