module Admin
  class ProductVariantsController < Admin::ApplicationController
    # Inherits all CRUD operations from Administrate::ApplicationController
    # Customizations can be added here if needed

    # Example: Override scoped_resource to filter by product if needed
    # def scoped_resource
    #   if params[:product_id].present?
    #     ProductVariant.where(product_id: params[:product_id])
    #   else
    #     super
    #   end
    # end
  end
end
