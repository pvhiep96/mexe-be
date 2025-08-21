ActiveAdmin.register Brand do
  permit_params :name, :slug, :description, :logo, :founded_year, :field, :story, :website, :sort_order, :is_active

  menu label: "Thương hiệu"

  index do
    selectable_column
    id_column
    column "Tên thương hiệu", :name
    column "Đường dẫn", :slug
    column "Năm thành lập", :founded_year
    column "Lĩnh vực", :field
    column "Thứ tự sắp xếp", :sort_order
    column "Kích hoạt", :is_active
    column "Ngày tạo", :created_at
    actions
  end

  filter :name
  filter :field
  filter :founded_year
  filter :is_active
  filter :created_at

  form do |f|
    f.inputs "Thông tin thương hiệu" do
      f.input :name, label: "Tên thương hiệu"
      f.input :slug, label: "Đường dẫn"
      f.input :description, label: "Mô tả"
      f.input :logo, label: "Logo"
      f.input :founded_year, label: "Năm thành lập"
      f.input :field, label: "Lĩnh vực"
      f.input :story, label: "Câu chuyện"
      f.input :website, label: "Website"
      f.input :sort_order, label: "Thứ tự sắp xếp"
      f.input :is_active, label: "Kích hoạt"
    end
    f.actions
  end

  show do
    attributes_table do
      row "ID", :id
      row "Tên thương hiệu", :name
      row "Đường dẫn", :slug
      row "Mô tả", :description
      row "Logo", :logo
      row "Năm thành lập", :founded_year
      row "Lĩnh vực", :field
      row "Câu chuyện", :story
      row "Website", :website
      row "Thứ tự sắp xếp", :sort_order
      row "Kích hoạt", :is_active
      row "Ngày tạo", :created_at
      row "Ngày cập nhật", :updated_at
    end
  end
end
