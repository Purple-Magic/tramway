module TramwayHelpers::Paths
  def index_page_for(model:)
    "#{path_prefix}/records?model=#{model}"
  end

  def path_prefix
    "/admin"
  end

  alias home_page path_prefix
end

RSpec.configure do |config|
  config.include TramwayHelpers::Paths
end
