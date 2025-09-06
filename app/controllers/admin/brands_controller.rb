module Admin
  class BrandsController < Admin::ApplicationController

    def index
      @brands = Brand.all.includes(:products).order(:name).page(params[:page]).per(5)
    end

  end
end
