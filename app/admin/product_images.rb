ActiveAdmin.register ProductImage do
  permit_params :product_id, :image, :alt_text, :sort_order, :is_primary

  menu label: "Hình ảnh sản phẩm"

  index do
    selectable_column
    id_column
    column "Sản phẩm", :product
    column "Hình ảnh", :image do |product_image|
      if product_image.image.attached?
        image_tag product_image.image, size: "50x50"
      else
        "Không có hình"
      end
    end
    column "Mô tả hình ảnh", :alt_text
    column "Thứ tự sắp xếp", :sort_order
    column "Hình chính", :is_primary
    column "Ngày tạo", :created_at
    actions
  end

  filter :product
  filter :is_primary
  filter :created_at

  form do |f|
    f.inputs "Thông tin hình ảnh sản phẩm" do
      f.input :product, label: "Sản phẩm"
      f.input :image, label: "Hình ảnh"
      f.input :alt_text, label: "Mô tả hình ảnh"
      f.input :sort_order, label: "Thứ tự sắp xếp"
      f.input :is_primary, label: "Hình chính"
    end
    f.actions
  end

  show do
    attributes_table do
      row "ID", :id
      row "Sản phẩm", :product
      row "Hình ảnh", :image do |product_image|
        if product_image.image.attached?
          image_tag product_image.image, size: "200x200"
        else
          "Không có hình"
        end
      end
      row "Mô tả hình ảnh", :alt_text
      row "Thứ tự sắp xếp", :sort_order
      row "Hình chính", :is_primary
      row "Ngày tạo", :created_at
      row "Ngày cập nhật", :updated_at
    end
  end
end
