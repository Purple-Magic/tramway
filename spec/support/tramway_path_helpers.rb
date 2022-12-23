module TramwayPathHelpers
  def index_page_for(model:)
    "#{path_prefix}/records?model=#{model}"
  end

  def path_prefix
    "/admin"
  end

  alias home_page path_prefix
end
