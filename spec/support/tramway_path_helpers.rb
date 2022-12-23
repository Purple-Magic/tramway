module TramwayPathHelpers
  def index_page_for(model:)
    "/admin/records?model=#{model}"
  end
end
