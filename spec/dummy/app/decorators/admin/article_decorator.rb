# frozen_string_literal: true

class Admin::ArticleDecorator < Tramway::BaseDecorator
  delegate_attributes :title

  def self.index_attributes
    %i[title]
  end

  def show_path
    article_path(object)
  end
end
