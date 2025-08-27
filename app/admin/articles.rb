ActiveAdmin.register Article do


  permit_params :title, :slug, :excerpt, :content, :featured_image, :author, :category, :tags, 
                :status, :published_at, :view_count, :meta_title, :meta_description

  menu label: "Bài viết"

  index do
    selectable_column
    id_column
    column "Ảnh" do |article|
      if article.featured_image.attached?
        image_tag article.featured_image, style: "width: 50px; height: 50px; object-fit: cover; border-radius: 4px;"
      else
        "Không có ảnh"
      end
    end
    column "Tiêu đề", :title
    column "Tác giả", :author
    column "Danh mục", :category
    column "Trạng thái", :status
    column "Ngày xuất bản", :published_at
    column "Lượt xem", :view_count
    column "Ngày tạo", :created_at
    actions
  end

  filter :title
  filter :author
  filter :category
  filter :status
  filter :published_at
  filter :created_at

  form do |f|
    f.inputs "Thông tin bài viết" do
      f.input :title, label: "Tiêu đề"
      f.input :slug, label: "Đường dẫn"
      f.input :excerpt, label: "Tóm tắt"
      f.input :content, as: :text, label: "Nội dung"
      f.input :featured_image, label: "Hình ảnh nổi bật", as: :file,
              hint: "Chọn ảnh nổi bật cho bài viết (JPG, PNG, GIF, tối đa 5MB)",
              input_html: { accept: 'image/*' }
      
      if f.object.featured_image.attached?
        div style: "margin: 15px 0; padding: 15px; background: #e8f4fd; border-radius: 8px; border: 1px solid #007cba;" do
          h4 "Ảnh nổi bật hiện tại:", style: "margin: 0 0 10px 0; color: #007cba;"
          image_tag f.object.featured_image, style: "max-width: 200px; max-height: 150px; object-fit: cover; border-radius: 6px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);"
        end
      end
      
      f.input :author, label: "Tác giả"
      f.input :category, label: "Danh mục"
      f.input :tags, label: "Thẻ"
      f.input :status, label: "Trạng thái"
      f.input :published_at, label: "Ngày xuất bản"
      f.input :meta_title, label: "Tiêu đề SEO"
      f.input :meta_description, label: "Mô tả SEO"
    end
    f.actions
  end

  show do
    attributes_table do
      row "ID", :id
      row "Tiêu đề", :title
      row "Đường dẫn", :slug
      row "Tóm tắt", :excerpt
      row "Nội dung", :content
      row "Hình ảnh nổi bật" do |article|
        if article.featured_image.attached?
          image_tag article.featured_image, style: "max-width: 300px; max-height: 200px; object-fit: cover; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);"
        else
          "Không có ảnh"
        end
      end
      row "Tác giả", :author
      row "Danh mục", :category
      row "Thẻ", :tags
      row "Trạng thái", :status
      row "Ngày xuất bản", :published_at
      row "Lượt xem", :view_count
      row "Tiêu đề SEO", :meta_title
      row "Mô tả SEO", :meta_description
      row "Ngày tạo", :created_at
      row "Ngày cập nhật", :updated_at
    end
  end
end
