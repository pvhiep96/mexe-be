ActiveAdmin.register Product do


  permit_params :name, :slug, :sku, :short_description, :brand_id, :category_id, 
                :price, :original_price, :discount_percent, :cost_price, 
                :stock_quantity, :min_stock_alert, :is_active, :is_featured, :is_new, :is_hot, 
                :is_preorder, :preorder_quantity, :preorder_end_date, :warranty_period, 
                :view_count, :main_image,
                product_specifications_attributes: [:id, :spec_name, :spec_value, :unit, :position, :is_active, :_destroy],
                product_descriptions_attributes: [:id, :title, :content, :position, :is_active, :_destroy],
                product_images_attributes: [:id, :image, :position, :is_active, :_destroy]

  menu label: "Sản phẩm"

  index do
    selectable_column
    id_column
    column "Ảnh" do |product|
      if product.persisted? && product.main_image && product.main_image.attached?
        image_tag product.main_image, style: "width: 50px; height: 50px; object-fit: cover;"
      else
        "Không có ảnh"
      end
    end
    column "Tên sản phẩm", :name
    column "Mã SKU", :sku
    column "Thương hiệu", :brand
    column "Danh mục", :category
    column "Giá", :price do |product|
      number_to_currency(product.price, unit: "₫", precision: 0)
    end
    column "Số lượng tồn kho", :stock_quantity
    column "Kích hoạt", :is_active
    column "Nổi bật", :is_featured
    column "Mới", :is_new
    column "Ngày tạo", :created_at
    actions
  end

  filter :name
  filter :sku
  filter :brand
  filter :category
  filter :price
  filter :is_active
  filter :is_featured
  filter :is_new
  filter :created_at

  form html: { multipart: true } do |f|
    f.inputs "Thông tin sản phẩm" do
      f.input :name, label: "Tên sản phẩm"
      f.input :slug, label: "Đường dẫn"
      f.input :sku, label: "Mã SKU"
      f.input :brand, label: "Thương hiệu"
      f.input :category, label: "Danh mục"
      f.input :short_description, label: "Mô tả ngắn"
      f.input :price, label: "Giá"
      f.input :original_price, label: "Giá gốc"
      f.input :discount_percent, label: "Phần trăm giảm giá"
      f.input :cost_price, label: "Giá vốn"
      f.input :stock_quantity, label: "Số lượng tồn kho"
      f.input :min_stock_alert, label: "Cảnh báo tồn kho tối thiểu"
      f.input :warranty_period, label: "Thời hạn bảo hành"
      f.input :is_active, label: "Kích hoạt"
      f.input :is_featured, label: "Nổi bật"
      f.input :is_new, label: "Mới"
      f.input :is_hot, label: "Hot"
      f.input :is_preorder, label: "Đặt trước"
      f.input :preorder_quantity, label: "Số lượng đặt trước"
      f.input :preorder_end_date, label: "Ngày kết thúc đặt trước"
    end

    f.inputs "Quản lý ảnh sản phẩm" do
      f.input :main_image, label: "Ảnh chính", as: :file, 
              hint: "Chọn ảnh chính cho sản phẩm (JPG, PNG, GIF, tối đa 5MB)",
              input_html: { accept: 'image/*' }
      
      if f.object.persisted? && f.object.main_image.attached?
        div class: "current-main-image" do
          h4 "Ảnh chính hiện tại:"
          image_tag f.object.main_image, style: "width: 150px; height: 150px; object-fit: cover; margin: 10px;"
        end
      end
      
      f.has_many :product_images, allow_destroy: true, new_record: "Thêm ảnh khác" do |img|
        img.input :image, label: "Chọn ảnh", as: :file, 
                  hint: "Chọn ảnh bổ sung (JPG, PNG, GIF, tối đa 5MB)",
                  input_html: { accept: 'image/*' }
        img.input :position, label: "Vị trí", 
                  hint: "Số càng nhỏ càng hiển thị trước (để trống để tự động)"
        img.input :is_active, label: "Kích hoạt"
        
        # Preview ảnh đã upload (chỉ hiển thị cho record đã lưu)
        if img.object.persisted? && img.object.image.attached?
          div class: "image-preview" do
            h5 "Preview ảnh:"
            image_tag img.object.image, style: "width: 120px; height: 120px; object-fit: cover; margin: 5px; border: 1px solid #ddd; border-radius: 4px;"
          end
        end
      end
      
      # Hiển thị tất cả ảnh bổ sung hiện tại
      if f.object.persisted? && f.object.product_images.active.any?
        div class: "current-additional-images" do
          h4 "Ảnh bổ sung hiện tại:"
          f.object.product_images.active.ordered.each do |product_image|
            if product_image.persisted? && product_image.image.attached?
              div class: "additional-image-item", style: "display: inline-block; margin: 10px; text-align: center; border: 1px solid #ddd; padding: 10px; border-radius: 5px;" do
                image_tag product_image.image, style: "width: 100px; height: 100px; object-fit: cover;"
                div class: "image-info" do
                  p "Vị trí: #{product_image.position}"
                  p "Trạng thái: #{product_image.is_active ? 'Kích hoạt' : 'Không kích hoạt'}"
                end
              end
            end
          end
        end
      end
    end

    f.inputs "Quản lý mô tả chi tiết" do
      f.has_many :product_descriptions, allow_destroy: true, new_record: "Thêm mô tả mới" do |desc|
        desc.input :title, label: "Tiêu đề", 
                   hint: "VD: Mô tả sản phẩm, Tính năng nổi bật, Hướng dẫn sử dụng"
        desc.input :content, label: "Nội dung", as: :text, 
                   input_html: { class: 'ckeditor', rows: 8 },
                   hint: "Sử dụng CKEditor để định dạng nội dung phong phú"
        desc.input :position, label: "Vị trí", 
                   hint: "Số càng nhỏ càng hiển thị trước (để trống để tự động)"
        desc.input :is_active, label: "Kích hoạt"
      end
    end

    f.inputs "Quản lý thông số kỹ thuật" do
      f.has_many :product_specifications, allow_destroy: true, new_record: "Thêm thông số mới" do |spec|
        spec.input :spec_name, label: "Tên thông số", 
                   hint: "VD: Trọng lượng, Kích thước, Chất liệu, Màu sắc, Trọng lượng tịnh"
        spec.input :spec_value, label: "Giá trị", as: :string,
                   hint: "VD: 500g, 10x20x30cm, Nhựa ABS, Đen, 450g"
        spec.input :unit, label: "Đơn vị", 
                   hint: "VD: g, cm, kg, inch, ml, lít (tùy chọn)"
        spec.input :position, label: "Vị trí", 
                   hint: "Số càng nhỏ càng hiển thị trước (để trống để tự động)"
        spec.input :is_active, label: "Kích hoạt"
      end
    end
    
    f.actions
  end

  show do
    attributes_table do
      row :id
      row "Ảnh chính" do |product|
        if product.persisted? && product.main_image && product.main_image.attached?
          image_tag product.main_image, style: "width: 200px; height: 200px; object-fit: cover;"
        else
          "Không có ảnh"
        end
      end
      row :name
      row :slug
      row :sku
      row :brand
      row :category
      row :short_description
      row :price do |product|
        number_to_currency(product.price, unit: "₫", precision: 0)
      end
      row :original_price do |product|
        number_to_currency(product.original_price, unit: "₫", precision: 0)
      end
      row :discount_percent
      row :cost_price
      row :stock_quantity
      row :min_stock_alert
      row :warranty_period
      row :is_active
      row :is_featured
      row :is_new
      row :is_hot
      row :is_preorder
      row :preorder_quantity
      row :preorder_end_date
      row :view_count
      row :created_at
      row :updated_at
    end

    if resource.has_images?
      panel "Thư viện ảnh" do
        if resource.persisted? && resource.main_image.attached?
          div class: "main-image-show" do
            h3 "Ảnh chính:"
            div class: "main-image-container" do
              image_tag resource.main_image, style: "width: 250px; height: 250px; object-fit: cover; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.2);"
            end
          end
        end
        
        if resource.product_images.active.any?
          div class: "gallery-images-show" do
            h3 "Ảnh bổ sung:"
            div class: "gallery-grid" do
              resource.product_images.active.ordered.each do |product_image|
                if product_image.persisted? && product_image.image.attached?
                  div class: "gallery-item" do
                    image_tag product_image.image, style: "width: 180px; height: 180px; object-fit: cover; border-radius: 6px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);"
                    div class: "item-meta" do
                      span "Vị trí: #{product_image.position} | "
                      span product_image.is_active ? "Kích hoạt" : "Không kích hoạt", class: "status_tag #{product_image.is_active ? 'ok' : 'error'}"
                    end
                  end
                end
              end
            end
          end
        end
      end
    end

    if resource.product_descriptions.any?
      panel "Mô tả chi tiết" do
        resource.product_descriptions.ordered.each do |description|
          div class: "description-item", style: "border: 1px solid #ddd; padding: 15px; margin: 10px 0; border-radius: 5px;" do
            h3 "#{description.title} (Vị trí: #{description.position})"
            div class: "description-content" do
              simple_format(description.content)
            end
            div class: "description-meta" do
              span "Trạng thái: ", class: "label"
              span description.is_active ? "Kích hoạt" : "Không kích hoạt", class: "status_tag #{description.is_active ? 'ok' : 'error'}"
              span " | Ngày tạo: #{description.created_at.strftime('%d/%m/%Y %H:%M')}"
            end
          end
        end
      end
    end

    if resource.product_specifications.any?
      panel "Thông số kỹ thuật" do
        resource.product_specifications.ordered.each do |spec|
          div class: "spec-item", style: "border: 1px solid #ddd; padding: 15px; margin: 10px 0; border-radius: 5px;" do
            h3 "#{spec.spec_name}: #{spec.spec_value}"
            div class: "spec-content" do
              p "Tên thông số: #{spec.spec_name}"
              p "Giá trị: #{spec.spec_value}"
              p "Đơn vị: #{spec.unit || 'Không có'}"
              p "Vị trí: #{spec.position}"
            end
            div class: "spec-meta" do
              span "Trạng thái: ", class: "label"
              span spec.is_active ? "Kích hoạt" : "Không kích hoạt", class: "status_tag #{spec.is_active ? 'ok' : 'error'}"
              span " | Ngày tạo: #{spec.created_at.strftime('%d/%m/%Y %H:%M')}"
            end
          end
        end
      end
    end
  end

  # Member actions để xóa ảnh
  member_action :delete_main_image, method: :delete do
    if resource.main_image.attached?
      resource.main_image.purge
      redirect_to resource_path, notice: "Đã xóa ảnh chính"
    else
      redirect_to resource_path, alert: "Không có ảnh chính để xóa"
    end
  end

  # Action items
  action_item :view_product, only: :show do
    link_to "Xem sản phẩm", "/products/#{resource.slug}", target: "_blank"
  end

  # Sidebar thống kê
  sidebar "Thống kê sản phẩm", only: :index do
    ul do
      li "Tổng số sản phẩm: #{Product.count}"
      li "Sản phẩm kích hoạt: #{Product.where(is_active: true).count}"
      li "Sản phẩm nổi bật: #{Product.where(is_featured: true).count}"
      li "Sản phẩm mới: #{Product.where(is_new: true).count}"
      li "Sản phẩm có ảnh: #{Product.joins(:product_images).distinct.count}"
      li "Sản phẩm có mô tả: #{Product.joins(:product_descriptions).distinct.count}"
      li "Sản phẩm có thông số: #{Product.joins(:product_specifications).distinct.count}"
    end
  end

  # Controller để xử lý upload ảnh và nested attributes
  controller do
    def create
      @product = Product.new(permitted_params[:product])
      
      # Debug logging
      Rails.logger.info "Creating product with params: #{permitted_params[:product].inspect}"
      
      if @product.save
        redirect_to resource_path(@product), notice: "Đã tạo sản phẩm thành công"
      else
        Rails.logger.error "Failed to create product: #{@product.errors.full_messages}"
        render :new
      end
    end

    def update
      @product = Product.find(params[:id])
      
      # Debug logging
      Rails.logger.info "Updating product with params: #{permitted_params[:product].inspect}"
      
      if @product.update(permitted_params[:product])
        redirect_to resource_path(@product), notice: "Đã cập nhật sản phẩm thành công"
      else
        Rails.logger.error "Failed to update product: #{@product.errors.full_messages}"
        render :edit
      end
    end
  end



  # CSS styles cho preview ảnh
  config do
    stylesheet do
      %Q{
        <style>
          .image-preview {
            margin: 10px 0;
            padding: 10px;
            background: #f9f9f9;
            border-radius: 5px;
            border-left: 3px solid #007cba;
          }
          
          .image-preview h5 {
            margin: 0 0 10px 0;
            color: #007cba;
            font-size: 14px;
          }
          
          .current-additional-images {
            margin-top: 20px;
            padding: 15px;
            background: #f5f5f5;
            border-radius: 8px;
            border: 1px solid #ddd;
          }
          
          .current-additional-images h4 {
            margin: 0 0 15px 0;
            color: #333;
            border-bottom: 2px solid #007cba;
            padding-bottom: 5px;
          }
          
          .additional-image-item {
            background: white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            transition: transform 0.2s;
          }
          
          .additional-image-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
          }
          
          .image-info p {
            margin: 2px 0;
            font-size: 12px;
            color: #666;
          }
          
          .current-main-image {
            margin: 15px 0;
            padding: 15px;
            background: #e8f4fd;
            border-radius: 8px;
            border: 1px solid #007cba;
          }
          
          .current-main-image h4 {
            margin: 0 0 10px 0;
            color: #007cba;
          }
          
          .main-image-show {
            margin: 20px 0;
            padding: 20px;
            background: #e8f4fd;
            border-radius: 10px;
            border: 2px solid #007cba;
          }
          
          .main-image-show h3 {
            margin: 0 0 15px 0;
            color: #007cba;
            font-size: 18px;
            border-bottom: 2px solid #007cba;
            padding-bottom: 8px;
          }
          
          .main-image-container {
            text-align: center;
          }
          
          .gallery-images-show {
            margin: 20px 0;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 10px;
            border: 1px solid #dee2e6;
          }
          
          .gallery-images-show h3 {
            margin: 0 0 20px 0;
            color: #495057;
            font-size: 18px;
            border-bottom: 2px solid #6c757d;
            padding-bottom: 8px;
          }
          
          .gallery-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 20px;
            margin-top: 20px;
          }
          
          .gallery-item {
            text-align: center;
            padding: 15px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            transition: transform 0.2s, box-shadow 0.2s;
          }
          
          .gallery-item:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 12px rgba(0,0,0,0.15);
          }
          
          .item-meta {
            margin-top: 10px;
            font-size: 12px;
            color: #6c757d;
          }
        </style>
      }
    end
  end
end
