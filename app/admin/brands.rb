ActiveAdmin.register Brand do


  permit_params :name, :slug, :description, :logo, :founded_year, :field, :story, :website, :sort_order, :is_active

  menu label: "Thương hiệu"

  index do
    selectable_column
    id_column
    column "Logo" do |brand|
      if brand.logo.attached?
        image_tag brand.logo, style: "width: 50px; height: 50px; object-fit: contain; border-radius: 4px;"
      else
        "Không có logo"
      end
    end
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
      f.input :logo, label: "Logo", as: :file,
              hint: "Chọn logo thương hiệu (JPG, PNG, GIF, tối đa 5MB)",
              input_html: { accept: 'image/*' }
      
      if f.object.logo.attached?
        div style: "margin: 15px 0; padding: 15px; background: #e8f4fd; border-radius: 8px; border: 1px solid #007cba;" do
          h4 "Logo hiện tại:", style: "margin: 0 0 10px 0; color: #007cba;"
          image_tag f.object.logo, style: "max-width: 200px; max-height: 150px; object-fit: contain; border-radius: 6px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);"
        end
      end
      
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
      row "Logo" do |brand|
        if brand.logo.attached?
          image_tag brand.logo, style: "max-width: 300px; max-height: 200px; object-fit: contain; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);"
        else
          "Không có logo"
        end
      end
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
