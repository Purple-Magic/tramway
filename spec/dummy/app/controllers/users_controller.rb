# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @users = User.all.page(params[:page])
  end
end
