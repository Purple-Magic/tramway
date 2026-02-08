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
end
