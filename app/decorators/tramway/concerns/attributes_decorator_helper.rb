# frozen_string_literal: true

module Tramway::Concerns::AttributesDecoratorHelper
  def date_view(value)
    I18n.l value.to_date if value
  end

  def datetime_view(value)
    I18n.l value if value
  end

  def state_machine_view(object, attribute_name)
    state = object.send(attribute_name)
    I18n.t("state_machines.#{object.class.model_name.to_s.underscore}.#{attribute_name}.states.#{state}")
  rescue StandardError
    object.aasm.human_state
  end

  BASE64_REGEXP = %r{^(?:[a-zA-Z0-9+/]{4})*(?:|(?:[a-zA-Z0-9+/]{3}=)|
                                            (?:[a-zA-Z0-9+/]{2}==)|(?:[a-zA-Z0-9+/]{1}===))$}x.freeze

  def image_view(original, thumb: nil, filename: nil)
    return unless original.present?

    filename ||= build_filename(original)
    content_tag(:div) do
      build_div_content src_original(original), src_thumb(original, thumb), filename || build_filename(original)
    end
  end

  def file_view(original, filename: nil)
    return unless original.present?

    filename ||= build_filename(original)
    content_tag(:div) do
      concat filename
      concat ' '
      concat download_button(filename: filename, original: original) if filename
    end
  end

  def enumerize_view(value)
    value.text
  end

  def yaml_view(value)
    content_tag(:pre) { value.to_yaml }
  end

  private

  def src_thumb(original, thumb)
    thumb ||= original.is_a?(CarrierWave::Uploader::Base) ? original.small : nil
    if thumb.is_a?(CarrierWave::Uploader::Base)
      thumb.url
    elsif thumb&.match(BASE64_REGEXP)
      "data:image/jpeg;base64,#{thumb}"
    else
      thumb
    end
  end

  def src_original(original)
    case original
    when CarrierWave::Uploader::Base
      original.url
    when BASE64_REGEXP
      "data:image/jpeg;base64,#{original}"
    else
      original
    end
  end

  def build_filename(original)
    original.is_a?(CarrierWave::Uploader::Base) ? original.path&.split('/')&.last : nil
  end

  def build_div_content(original, thumb, filename)
    begin
      concat image_tag src_thumb(original, thumb) || src_original(original)
    rescue NoMethodError => e
      Tramway::Error.raise_error(
        :tramway, :concerns, :attributes_decorator_helper, :you_should_mount_photo_uploader,
        message: e.message, attribute_name: attribute_name
      )
    end
    concat download_button(filename: filename, original: original) if filename
  end

  def download_button(filename:, original:)
    link_to(fa_icon(:download), src_original(original), class: 'btn btn-success', download: filename)
  end

  def yes_no(boolean_attr)
    boolean_attr.to_s == 'true' ? I18n.t('helpers.yes') : I18n.t('helpers.no')
  end
end
