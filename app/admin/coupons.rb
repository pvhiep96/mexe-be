ActiveAdmin.register Coupon do
  permit_params :code, :discount_type, :discount_value, :min_amount, :max_discount, :usage_limit, :used_count, :valid_from, :valid_until, :is_active

  menu label: "Mã giảm giá"

  index do
    selectable_column
    id_column
    column "Mã giảm giá", :code
    column "Loại giảm giá", :discount_type
    column "Giá trị giảm giá", :discount_value
    column "Giá trị đơn hàng tối thiểu", :min_amount do |coupon|
      number_to_currency(coupon.min_amount, unit: "₫", precision: 0)
    end
    column "Giảm giá tối đa", :max_discount do |coupon|
      number_to_currency(coupon.max_discount, unit: "₫", precision: 0)
    end
    column "Giới hạn sử dụng", :usage_limit
    column "Số lần đã sử dụng", :used_count
    column "Có hiệu lực từ", :valid_from
    column "Có hiệu lực đến", :valid_until
    column "Kích hoạt", :is_active
    column "Ngày tạo", :created_at
    actions
  end

  filter :code
  filter :discount_type
  filter :is_active
  filter :valid_from
  filter :valid_until
  filter :created_at

  form do |f|
    f.inputs "Thông tin mã giảm giá" do
      f.input :code, label: "Mã giảm giá"
      f.input :discount_type, label: "Loại giảm giá", as: :select, collection: [["Phần trăm", "percentage"], ["Số tiền cố định", "fixed"]]
      f.input :discount_value, label: "Giá trị giảm giá"
      f.input :min_amount, label: "Giá trị đơn hàng tối thiểu"
      f.input :max_discount, label: "Giảm giá tối đa"
      f.input :usage_limit, label: "Giới hạn sử dụng"
      f.input :valid_from, label: "Có hiệu lực từ"
      f.input :valid_until, label: "Có hiệu lực đến"
      f.input :is_active, label: "Kích hoạt"
    end
    f.actions
  end

  show do
    attributes_table do
      row "ID", :id
      row "Mã giảm giá", :code
      row "Loại giảm giá", :discount_type
      row "Giá trị giảm giá", :discount_value
      row "Giá trị đơn hàng tối thiểu", :min_amount do |coupon|
        number_to_currency(coupon.min_amount, unit: "₫", precision: 0)
      end
      row "Giảm giá tối đa", :max_discount do |coupon|
        number_to_currency(coupon.max_discount, unit: "₫", precision: 0)
      end
      row "Giới hạn sử dụng", :usage_limit
      row "Số lần đã sử dụng", :used_count
      row "Có hiệu lực từ", :valid_from
      row "Có hiệu lực đến", :valid_until
      row "Kích hoạt", :is_active
      row "Ngày tạo", :created_at
      row "Ngày cập nhật", :updated_at
    end
  end
end
