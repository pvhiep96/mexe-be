module Admin
  class CategoriesController < Admin::ApplicationController

    def index
      @categories = Category.all.includes(:products).order(:name)
    end

  end
end
