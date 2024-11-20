module Tramway::Helpers::ComponentHelper
  def component(name, *, **, &)
    render("#{name}_component".classify.constantize.new(*, **), &)
  end
end
