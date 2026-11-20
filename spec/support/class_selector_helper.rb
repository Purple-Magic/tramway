# frozen_string_literal: true

module ClassSelectorHelper
  def class_selector(classes)
    Array(classes)
      .flat_map { |klass| klass.to_s.split }
      .map { |klass| klass.gsub(':', '\\:').gsub('/', '\\/') }
      .join('.')
  end
end
