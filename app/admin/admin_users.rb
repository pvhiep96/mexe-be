ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation

  menu label: "Quản trị viên"

  index do
    selectable_column
    id_column
    column "Email", :email
    column "Lần đăng nhập cuối", :current_sign_in_at
    column "Số lần đăng nhập", :sign_in_count
    column "Ngày tạo", :created_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs "Thông tin quản trị viên" do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
