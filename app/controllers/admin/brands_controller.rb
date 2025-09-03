module Admin
  class BrandsController < Admin::ApplicationController

    def index
      @brands = Brand.all.includes(:products).order(:name)
    end

  end
end
