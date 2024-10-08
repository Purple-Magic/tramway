# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @users = User.all.page(params[:page])
  end

  def new
    @user_form = tramway_form User.new
  end

  def create
    @user = tramway_form User.new

    if @user.submit params[:user]
      render :show
    else
      render :new
    end
  end
end
