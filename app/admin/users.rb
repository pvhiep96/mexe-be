ActiveAdmin.register User do
  permit_params :email, :full_name, :phone, :date_of_birth, :gender, :is_active, :is_verified

  menu label: "Người dùng"

  index do
    selectable_column
    id_column
    column "Email", :email
    column "Họ và tên", :full_name
    column "Số điện thoại", :phone
    column "Kích hoạt", :is_active
    column "Đã xác thực", :is_verified
    column "Ngày tạo", :created_at
    actions
  end

  filter :email
  filter :full_name
  filter :phone
  filter :is_active
  filter :is_verified
  filter :created_at

  form do |f|
    f.inputs "Thông tin người dùng" do
      f.input :email, label: "Email"
      f.input :full_name, label: "Họ và tên"
      f.input :phone, label: "Số điện thoại"
      f.input :date_of_birth, label: "Ngày sinh"
      f.input :gender, label: "Giới tính"
      f.input :is_active, label: "Kích hoạt"
      f.input :is_verified, label: "Đã xác thực"
    end
    f.actions
  end

  show do
    attributes_table do
      row "ID", :id
      row "Email", :email
      row "Họ và tên", :full_name
      row "Số điện thoại", :phone
      row "Ngày sinh", :date_of_birth
      row "Giới tính", :gender
      row "Kích hoạt", :is_active
      row "Đã xác thực", :is_verified
      row "Ngày tạo", :created_at
      row "Ngày cập nhật", :updated_at
    end
  end
end
