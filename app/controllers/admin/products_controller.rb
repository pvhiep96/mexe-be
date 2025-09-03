module Admin
  class ProductsController < Admin::ApplicationController

    def new
      resource = resource_class.new
      resource.product_images.build
      resource.product_descriptions.build
      resource.product_specifications.build
      resource.product_videos.build
      authorize_resource(resource)
      render locals: { page: Administrate::Page::Form.new(dashboard, resource) }
    end

    def edit
      render locals: { page: Administrate::Page::Form.new(dashboard, requested_resource) }
    end

    private

    def resource_params
      params.require(resource_class.model_name.param_key).permit(
        dashboard.permitted_attributes(action_name) +
        [
          product_images_attributes: [:id, :image, :alt_text, :sort_order, :is_primary, :_destroy],
          product_descriptions_attributes: [:id, :title, :content, :sort_order, :_destroy],
          product_specifications_attributes: [:id, :spec_name, :spec_value, :unit, :position, :_destroy],
          product_videos_attributes: [:id, :url, :title, :description, :sort_order, :is_active, :_destroy]
        ]
      )
    end
  end
end
