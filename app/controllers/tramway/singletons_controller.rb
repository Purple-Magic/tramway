# frozen_string_literal: true

module Tramway
  class SingletonsController < ApplicationController
    def show
      if model_class.first.present?
        @singleton = decorator_class.decorate model_class.first
      else
        @singleton_form = admin_form_class.new model_class.new
        render :new
        nil
      end
    end

    def edit
      @singleton_form = admin_form_class.new model_class.first
    end

    def create
      @singleton_form = admin_form_class.new model_class.new
      if @singleton_form.submit params[:singleton]
        redirect_to params[:redirect] || singleton_path(model: params[:model])
      else
        render :edit
      end
    end

    def update
      @singleton_form = admin_form_class.new model_class.first
      if @singleton_form.submit params[:singleton]
        redirect_to params[:redirect] || singleton_path(model: params[:model])
      else
        render :edit
      end
    end
  end

  private

  # FIXME: replace to module
  def singleton_path(*args, **options)
    super args, options.merge(model: params[:model])
  end

  def edit_singleton_path(*args, **options)
    super args, options.merge(model: params[:model])
  end
end
