ActiveAdmin.register Order do
  permit_params :user_id, :order_number, :subtotal, :total_amount, :payment_method, :status, 
                :payment_status, :delivery_type, :shipping_address, :billing_address, :notes, 
                :tracking_number, :shipped_at, :delivered_at

  menu label: "Đơn hàng"

  index do
    selectable_column
    id_column
    column "Mã đơn hàng", :order_number
    column "Khách hàng", :user
    column "Tổng tiền", :total_amount do |order|
      number_to_currency(order.total_amount, unit: "₫", precision: 0)
    end
    column "Trạng thái", :status
    column "Trạng thái thanh toán", :payment_status
    column "Phương thức thanh toán", :payment_method
    column "Loại giao hàng", :delivery_type
    column "Ngày tạo", :created_at
    actions
  end

  filter :order_number
  filter :user
  filter :status
  filter :payment_status
  filter :payment_method
  filter :delivery_type
  filter :total_amount
  filter :created_at

  form do |f|
    f.inputs "Thông tin đơn hàng" do
      f.input :user, label: "Khách hàng"
      f.input :order_number, label: "Mã đơn hàng"
      f.input :subtotal, label: "Tổng tiền hàng"
      f.input :total_amount, label: "Tổng tiền"
      f.input :payment_method, label: "Phương thức thanh toán"
      f.input :status, label: "Trạng thái"
      f.input :payment_status, label: "Trạng thái thanh toán"
      f.input :delivery_type, label: "Loại giao hàng"
      f.input :shipping_address, label: "Địa chỉ giao hàng"
      f.input :billing_address, label: "Địa chỉ thanh toán"
      f.input :notes, label: "Ghi chú"
      f.input :tracking_number, label: "Mã theo dõi"
      f.input :shipped_at, label: "Ngày giao hàng"
      f.input :delivered_at, label: "Ngày nhận hàng"
    end
    f.actions
  end

  show do
    attributes_table do
      row "ID", :id
      row "Mã đơn hàng", :order_number
      row "Khách hàng", :user
      row "Tổng tiền hàng", :subtotal do |order|
        number_to_currency(order.subtotal, unit: "₫", precision: 0)
      end
      row "Tổng tiền", :total_amount do |order|
        number_to_currency(order.total_amount, unit: "₫", precision: 0)
      end
      row "Phương thức thanh toán", :payment_method
      row "Trạng thái", :status
      row "Trạng thái thanh toán", :payment_status
      row "Loại giao hàng", :delivery_type
      row "Địa chỉ giao hàng", :shipping_address
      row "Địa chỉ thanh toán", :billing_address
      row "Ghi chú", :notes
      row "Mã theo dõi", :tracking_number
      row "Ngày giao hàng", :shipped_at
      row "Ngày nhận hàng", :delivered_at
      row "Ngày tạo", :created_at
      row "Ngày cập nhật", :updated_at
    end
  end
end
