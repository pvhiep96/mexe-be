ActiveAdmin.register Product do
  permit_params :name, :slug, :sku, :description, :short_description, :brand_id, :category_id, 
                :price, :original_price, :discount_percent, :cost_price, :weight, :dimensions, 
                :stock_quantity, :min_stock_alert, :is_active, :is_featured, :is_new, :is_hot, 
                :is_preorder, :preorder_quantity, :preorder_end_date, :warranty_period, 
                :meta_title, :meta_description, :view_count

  menu label: "Sản phẩm"

  index do
    selectable_column
    id_column
    column "Tên sản phẩm", :name
    column "Mã SKU", :sku
    column "Thương hiệu", :brand
    column "Danh mục", :category
    column "Giá", :price do |product|
      number_to_currency(product.price, unit: "₫", precision: 0)
    end
    column "Số lượng tồn kho", :stock_quantity
    column "Kích hoạt", :is_active
    column "Nổi bật", :is_featured
    column "Mới", :is_new
    column "Ngày tạo", :created_at
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
    f.inputs "Thông tin sản phẩm" do
      f.input :name, label: "Tên sản phẩm"
      f.input :slug, label: "Đường dẫn"
      f.input :sku, label: "Mã SKU"
      f.input :brand, label: "Thương hiệu"
      f.input :category, label: "Danh mục"
      f.input :description, label: "Mô tả"
      f.input :short_description, label: "Mô tả ngắn"
      f.input :price, label: "Giá"
      f.input :original_price, label: "Giá gốc"
      f.input :discount_percent, label: "Phần trăm giảm giá"
      f.input :cost_price, label: "Giá vốn"
      f.input :weight, label: "Trọng lượng"
      f.input :dimensions, label: "Kích thước"
      f.input :stock_quantity, label: "Số lượng tồn kho"
      f.input :min_stock_alert, label: "Cảnh báo tồn kho tối thiểu"
      f.input :warranty_period, label: "Thời hạn bảo hành"
      f.input :is_active, label: "Kích hoạt"
      f.input :is_featured, label: "Nổi bật"
      f.input :is_new, label: "Mới"
      f.input :is_hot, label: "Hot"
      f.input :is_preorder, label: "Đặt trước"
      f.input :preorder_quantity, label: "Số lượng đặt trước"
      f.input :preorder_end_date, label: "Ngày kết thúc đặt trước"
      f.input :meta_title, label: "Tiêu đề SEO"
      f.input :meta_description, label: "Mô tả SEO"
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
