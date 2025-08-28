ActiveAdmin.register Category do
  permit_params :name, :slug, :description, :parent_id, :sort_order, :is_active, :meta_title, :meta_description

  menu label: "Danh mục"

  index do
    selectable_column
    id_column
    column "Tên danh mục", :name
    column "Đường dẫn", :slug
    column "Danh mục cha", :parent
    column "Thứ tự sắp xếp", :sort_order
    column "Kích hoạt", :is_active
    column "Ngày tạo", :created_at
    actions
  end

  filter :name
  filter :parent
  filter :is_active
  filter :created_at

  form do |f|
    f.inputs "Thông tin danh mục" do
      f.input :name, label: "Tên danh mục"
      f.input :slug, label: "Đường dẫn"
      f.input :description, label: "Mô tả"
      f.input :parent, label: "Danh mục cha"
      f.input :sort_order, label: "Thứ tự sắp xếp"
      f.input :is_active, label: "Kích hoạt"
      f.input :meta_title, label: "Tiêu đề SEO"
      f.input :meta_description, label: "Mô tả SEO"
    end
    f.actions
  end

  show do
    attributes_table do
      row "ID", :id
      row "Tên danh mục", :name
      row "Đường dẫn", :slug
      row "Mô tả", :description
      row "Danh mục cha", :parent
      row "Thứ tự sắp xếp", :sort_order
      row "Kích hoạt", :is_active
      row "Tiêu đề SEO", :meta_title
      row "Mô tả SEO", :meta_description
      row "Ngày tạo", :created_at
      row "Ngày cập nhật", :updated_at
    end
  end
end
