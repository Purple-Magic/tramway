module Tramway::Views::KaminariExtension
  def paginate(scope, options = {}, &block)
    options[:theme] ||= :tramway

    super(scope, options, &block)
  end
end
