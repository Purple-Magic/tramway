# frozen_string_literal: true

module TramwayHelpers::Paths
  def index_page_for(model:)
    "#{path_prefix}/records?model=#{model}"
  end

  def path_prefix
    '/admin'
  end

  def edit_page_for(object, **options)
    Tramway::Engine.routes.url_helpers.edit_record_path(object.id, model: object.class, **options)
  end

  alias home_page path_prefix
end

RSpec.configure do |config|
  config.include TramwayHelpers::Paths
end
