# frozen_string_literal: true

class ArticleDecorator < Tramway::BaseDecorator
  delegate_attributes :title

  def self.list_attributes
    %i[title]
  end

  def show_path
    article_path(object)
  end
end
