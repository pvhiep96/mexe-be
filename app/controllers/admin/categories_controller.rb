module Admin
  class CategoriesController < Admin::ApplicationController

    def index
      @categories = Category.all.includes(:products).order(:name).page(params[:page]).per(5)
    end

  end
end
