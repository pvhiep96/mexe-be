ActiveAdmin.register ProductVariant do
  permit_params :product_id, :name, :sku, :price, :original_price, :stock_quantity, :is_active

  menu label: "Biến thể sản phẩm"

  index do
    selectable_column
    id_column
    column "Sản phẩm", :product
    column "Tên biến thể", :name
    column "Mã SKU", :sku
    column "Giá", :price do |variant|
      number_to_currency(variant.price, unit: "₫", precision: 0)
    end
    column "Giá gốc", :original_price do |variant|
      number_to_currency(variant.original_price, unit: "₫", precision: 0)
    end
    column "Số lượng tồn kho", :stock_quantity
    column "Kích hoạt", :is_active
    column "Ngày tạo", :created_at
    actions
  end

  filter :product
  filter :name
  filter :sku
  filter :is_active
  filter :created_at

  form do |f|
    f.inputs "Thông tin biến thể sản phẩm" do
      f.input :product, label: "Sản phẩm"
      f.input :name, label: "Tên biến thể"
      f.input :sku, label: "Mã SKU"
      f.input :price, label: "Giá"
      f.input :original_price, label: "Giá gốc"
      f.input :stock_quantity, label: "Số lượng tồn kho"
      f.input :is_active, label: "Kích hoạt"
    end
    f.actions
  end

  show do
    attributes_table do
      row "ID", :id
      row "Sản phẩm", :product
      row "Tên biến thể", :name
      row "Mã SKU", :sku
      row "Giá", :price do |variant|
        number_to_currency(variant.price, unit: "₫", precision: 0)
      end
      row "Giá gốc", :original_price do |variant|
        number_to_currency(variant.original_price, unit: "₫", precision: 0)
      end
      row "Số lượng tồn kho", :stock_quantity
      row "Kích hoạt", :is_active
      row "Ngày tạo", :created_at
      row "Ngày cập nhật", :updated_at
    end
  end
end
