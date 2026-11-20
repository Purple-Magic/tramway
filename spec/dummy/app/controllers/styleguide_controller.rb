# frozen_string_literal: true

# Visual test bench: renders every Tramway component in every state.
class StyleguideController < ApplicationController
  layout 'styleguide'

  def show
    @user_form = tramway_form User.new
    @users = User.all.page(params[:page])
  end
end
