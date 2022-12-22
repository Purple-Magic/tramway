# frozen_string_literal: true

class Tramway::Application
  attr_accessor :name, :url, :model_class, :title, :tagline, :found_date, :phone, :email, :main_image, :favicon,
                :short_description

  def public_name
    name.to_s.gsub('_', ' ').camelize
  end
end
