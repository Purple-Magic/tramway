# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('dummy/config/environment', __dir__)
require 'pry'

def bad_ass_monkey_patching_methods(source:)
  methods = deep_symbolize_values(
    YAML.load_file(Rails.root.join('..', 'yaml', 'methods.yml')).deep_symbolize_keys[:methods]
  )
  source = [source] unless source.is_a? Array
  methods.dig(*source)
end

def deep_symbolize_values(hash)
  hash.reduce({}) do |symbol_hash, pair|
    symbol_hash.merge! pair[0] => case pair[1].class.to_s
                                  when 'String'
                                    pair[1].to_sym
                                  when 'Hash'
                                    deep_symbolize_values(pair[1])
                                  when 'Array'
                                    pair[1].map(&:to_sym)
                                  else
                                    pair[1]
                                  end
  end
end
