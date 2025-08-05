ActiveAdmin.register Product do
  permit_params :name, :slug, :sku, :description, :short_description, :brand_id, :category_id, 
                :price, :original_price, :discount_percent, :cost_price, :weight, :dimensions, 
                :stock_quantity, :min_stock_alert, :is_active, :is_featured, :is_new, :is_hot, 
                :is_preorder, :preorder_quantity, :preorder_end_date, :warranty_period, 
                :meta_title, :meta_description, :view_count

  index do
    selectable_column
    id_column
    column :name
    column :sku
    column :brand
    column :category
    column :price do |product|
      number_to_currency(product.price, unit: "₫", precision: 0)
    end
    column :stock_quantity
    column :is_active
    column :is_featured
    column :is_new
    column :created_at
    actions
  end

  filter :name
  filter :sku
  filter :brand
  filter :category
  filter :price
  filter :is_active
  filter :is_featured
  filter :is_new
  filter :created_at

  form do |f|
    f.inputs do
      f.input :name
      f.input :slug
      f.input :sku
      f.input :brand
      f.input :category
      f.input :description
      f.input :short_description
      f.input :price
      f.input :original_price
      f.input :discount_percent
      f.input :cost_price
      f.input :weight
      f.input :dimensions
      f.input :stock_quantity
      f.input :min_stock_alert
      f.input :warranty_period
      f.input :is_active
      f.input :is_featured
      f.input :is_new
      f.input :is_hot
      f.input :is_preorder
      f.input :preorder_quantity
      f.input :preorder_end_date
      f.input :meta_title
      f.input :meta_description
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :slug
      row :sku
      row :brand
      row :category
      row :description
      row :short_description
      row :price do |product|
        number_to_currency(product.price, unit: "₫", precision: 0)
      end
      row :original_price do |product|
        number_to_currency(product.original_price, unit: "₫", precision: 0)
      end
      row :discount_percent
      row :cost_price
      row :weight
      row :dimensions
      row :stock_quantity
      row :min_stock_alert
      row :warranty_period
      row :is_active
      row :is_featured
      row :is_new
      row :is_hot
      row :is_preorder
      row :preorder_quantity
      row :preorder_end_date
      row :meta_title
      row :meta_description
      row :view_count
      row :created_at
      row :updated_at
    end
  end
end
