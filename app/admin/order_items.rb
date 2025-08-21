ActiveAdmin.register OrderItem do
  permit_params :order_id, :product_id, :product_variant_id, :quantity, :unit_price, :total_price

  menu label: "Chi tiết đơn hàng"

  index do
    selectable_column
    id_column
    column "Đơn hàng", :order
    column "Sản phẩm", :product
    column "Biến thể sản phẩm", :product_variant
    column "Số lượng", :quantity
    column "Đơn giá", :unit_price do |item|
      number_to_currency(item.unit_price, unit: "₫", precision: 0)
    end
    column "Tổng tiền", :total_price do |item|
      number_to_currency(item.total_price, unit: "₫", precision: 0)
    end
    column "Ngày tạo", :created_at
    actions
  end

  filter :order
  filter :product
  filter :product_variant
  filter :created_at

  form do |f|
    f.inputs "Thông tin chi tiết đơn hàng" do
      f.input :order, label: "Đơn hàng"
      f.input :product, label: "Sản phẩm"
      f.input :product_variant, label: "Biến thể sản phẩm"
      f.input :quantity, label: "Số lượng"
      f.input :unit_price, label: "Đơn giá"
      f.input :total_price, label: "Tổng tiền"
    end
    f.actions
  end

  show do
    attributes_table do
      row "ID", :id
      row "Đơn hàng", :order
      row "Sản phẩm", :product
      row "Biến thể sản phẩm", :product_variant
      row "Số lượng", :quantity
      row "Đơn giá", :unit_price do |item|
        number_to_currency(item.unit_price, unit: "₫", precision: 0)
      end
      row "Tổng tiền", :total_price do |item|
        number_to_currency(item.total_price, unit: "₫", precision: 0)
      end
      row "Ngày tạo", :created_at
      row "Ngày cập nhật", :updated_at
    end
  end
end
