class RentDecorator < Tramway::ApplicationDecorator
  decorate_association :reader

  def title
    reader.title
  end
end
