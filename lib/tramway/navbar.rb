# frozen_string_literal: true

module Tramway::Navbar
  def navbar_structure(*links, project:)
    @navbar_structure ||= {}
    @navbar_structure.merge! project => links
  end

  def navbar_items_for(project, role:)
    project = project.underscore.to_sym unless project.is_a? Symbol

    return [] unless @navbar_structure&.dig(project).present?

    @navbar_structure[project].map { |item| add_to_navbar item, project, role }.compact || []
  end

  private

  def should_be_in_navbar_as(item, project, role)
    if singleton_models_for(project, role: role).map(&:to_s).include?(item.to_s)
      { item.to_s => :singleton }
    elsif available_models_for(project, role: role).map(&:to_s).include?(item.to_s)
      { item.to_s => :record }
    elsif item.is_a? Symbol
      :divider
    end
  end

  def parse_hash_options_to_navbar(item, project, role)
    sub_items = item.values.first.map do |sub_item|
      should_be_in_navbar_as sub_item, project, role
    end.compact
    { item.keys.first => sub_items } if sub_items.any?
  end

  def add_to_navbar(item, project, role)
    case item
    when Class, String
      should_be_in_navbar_as item, project, role
    when Hash
      parse_hash_options_to_navbar item, project, role
    end
  end
end
