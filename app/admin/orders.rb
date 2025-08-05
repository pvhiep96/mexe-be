ActiveAdmin.register Order do
  permit_params :user_id, :order_number, :subtotal, :total_amount, :payment_method, :status, 
                :payment_status, :delivery_type, :shipping_address, :billing_address, :notes, 
                :tracking_number, :shipped_at, :delivered_at

  index do
    selectable_column
    id_column
    column :order_number
    column :user
    column :total_amount do |order|
      number_to_currency(order.total_amount, unit: "₫", precision: 0)
    end
    column :status
    column :payment_status
    column :payment_method
    column :delivery_type
    column :created_at
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
    f.inputs do
      f.input :user
      f.input :order_number
      f.input :subtotal
      f.input :total_amount
      f.input :payment_method
      f.input :status
      f.input :payment_status
      f.input :delivery_type
      f.input :shipping_address
      f.input :billing_address
      f.input :notes
      f.input :tracking_number
      f.input :shipped_at
      f.input :delivered_at
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :order_number
      row :user
      row :subtotal do |order|
        number_to_currency(order.subtotal, unit: "₫", precision: 0)
      end
      row :total_amount do |order|
        number_to_currency(order.total_amount, unit: "₫", precision: 0)
      end
      row :payment_method
      row :status
      row :payment_status
      row :delivery_type
      row :shipping_address
      row :billing_address
      row :notes
      row :tracking_number
      row :shipped_at
      row :delivered_at
      row :created_at
      row :updated_at
    end
  end
end
