class RentDecorator < Tramway::ApplicationDecorator
  decorate_associations :reader, :book

  def title
    reader.title
  end
end
