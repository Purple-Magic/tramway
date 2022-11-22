# frozen_string_literal: true

class Tramway::Error < RuntimeError
  def initialize(*args, plugin: nil, method: nil, message: nil)
    @properties = {}
    @properties[:plugin] = plugin
    @properties[:method] = method
    @properties[:message] = message
    super(*args)
  end

  def message
    "Plugin: #{@properties[:plugin]}; Method: #{@properties[:method]}; Message: #{@properties[:message]}"
  end

  def properties
    @properties ||= {}
  end

  class << self
    def raise_error(*coordinates, **options)
      @errors ||= YAML.load_file("#{Tramway::Core.root}/yaml/errors.yml").with_indifferent_access
      error = @errors.dig(*coordinates)
      raise 'Error is not defined in YAML' unless error

      options.each do |pair|
        error.gsub!("%{#{pair[0]}}", pair[1].to_s)
      end
      raise error
    end
  end
end
