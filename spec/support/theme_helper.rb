# frozen_string_literal: true

module ThemeHelper
  def class_selector(classes)
    Array(classes)
      .flat_map { |klass| klass.to_s.split }
      .map { |klass| klass.gsub(/[^a-zA-Z0-9_-]/) { |character| "\\#{character}" } }
      .join('.')
  end

  def with_theme(theme)
    previous_theme = Tramway.config.theme
    Tramway.config.theme = theme
    yield
  ensure
    Tramway.config.theme = previous_theme
  end
end
