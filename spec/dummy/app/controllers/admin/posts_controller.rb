# frozen_string_literal: true

module Admin
  # Demonstrates Tramway Custom Pages: a host app controller that handles
  # entity actions beyond the built-in CRUD ones, reusing the Tramway layout/navbar.
  class PostsController < Tramway::EntitiesController
    def stats
      @posts_count = Post.count
    end

    def export
      @post = model_class.find(params.expect(:id))
      @kind = params[:kind]
    end
  end
end
