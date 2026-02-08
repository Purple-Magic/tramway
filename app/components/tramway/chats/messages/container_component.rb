class Tramway::Chats::Messages::ContainerComponent < Tramway::BaseComponent
  option :position
  option :text
  option :sent_at

  def position_classes
    case position.to_sym
    when :left
      ['items-start']
    when :right
      ['items-end']
    end.join(' ')
  end

  def color_classes
    case position.to_sym
    when :left
      ['bg-gray-800', 'rounded-tl-md']
    when :right
      ['bg-blue-600', 'rounded-tr-md']
    end.join(' ')
  end
end
