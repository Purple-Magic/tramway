# frozen_string_literal: true

module ImageDefaults
  include CarrierWave::MiniMagick

  def default_url
    "/images/fallback/#{model.class.model_name.to_s.underscore}/" <<
      [mounted_as, version_name].compact.join('_') << '.gif'
  end

  def extension_allowlist
    model.class.file_extensions || %w[jpg jpeg gif png]
  end
end
