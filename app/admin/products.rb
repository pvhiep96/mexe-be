ActiveAdmin.register Product do


  permit_params :name, :slug, :sku, :short_description, :brand_id, :category_id, 
                :price, :original_price, :discount_percent, :cost_price, 
                :stock_quantity, :min_stock_alert, :is_active, :is_featured, :is_new, :is_hot, 
                :is_preorder, :preorder_quantity, :preorder_end_date, :warranty_period, 
                :view_count, :main_image, { images: [] },
                product_specifications_attributes: [:id, :spec_name, :spec_value, :unit, :position, :is_active, :_destroy],
                product_descriptions_attributes: [:id, :title, :content, :position, :is_active, :_destroy]

  menu label: "Sản phẩm"

  index do
    selectable_column
    id_column
    column "Ảnh" do |product|
      if product.persisted? && product.main_image.present?
        image_tag product.main_image.url(:thumb), style: "width: 50px; height: 50px; object-fit: cover;"
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
    # Main form inputs using same layout as show page
    f.inputs do
      f.input :name, label: "Tên sản phẩm"
      f.input :slug, label: "Đường dẫn"
      f.input :sku, label: "Mã SKU"
      f.input :brand, label: "Thương hiệu"
      f.input :category, label: "Danh mục"
      f.input :short_description, label: "Mô tả ngắn", input_html: { rows: 3 }
      f.input :price, label: "Giá bán"
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
      f.input :view_count, label: "Lượt xem"
    end

    # Image management panel - same style as show page
    panel "Thư viện ảnh" do
      # Hướng dẫn sử dụng
      div class: "image-upload-guide" do
        h4 "📖 Hướng dẫn upload ảnh"
        ul do
          li "🖼️ **Ảnh chính**: Ảnh đại diện chính của sản phẩm, hiển thị trong danh sách và trang chi tiết"
          li "📸 **Ảnh bổ sung**: Thêm nhiều góc nhìn khác nhau về sản phẩm"
          li "📏 **Kích thước khuyến nghị**: Tối thiểu 600x600px, tỷ lệ vuông (1:1) cho đẹp nhất"
          li "💾 **Định dạng hỗ trợ**: JPG, PNG, GIF. Dung lượng tối đa: 5MB/ảnh"
          li "🔢 **Vị trí**: Số nhỏ hiển thị trước. Để trống = tự động sắp xếp"
          li "✅ **Kích hoạt**: Chỉ ảnh được kích hoạt mới hiển thị trên website"
        end
      end

      f.input :main_image, label: "Ảnh chính", as: :file, 
              hint: "Chọn ảnh chính cho sản phẩm (JPG, PNG, GIF, tối đa 5MB)",
              input_html: { accept: 'image/*', id: 'main_image_input' }
      
      # Preview container for new main image
      div id: "main_image_preview", class: "main-image-preview", style: "display: none; margin: 15px 0; padding: 15px; background: #f8f9fa; border-radius: 8px; border: 1px solid #dee2e6;" do
        h4 "Preview ảnh chính mới:"
        div id: "main_image_preview_container", class: "main-image-container"
      end
      
      if f.object.persisted? && f.object.main_image.present?
        div class: "main-image-show" do
          h3 "Ảnh chính:"
          div class: "main-image-container" do
            image_tag f.object.main_image.url(:large), style: "width: 250px; height: 250px; object-fit: cover; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.2);"
          end
          div class: "image-actions", style: "margin-top: 10px; text-align: center;" do
            link_to "🗑️ Xóa ảnh chính", delete_main_image_admin_product_path(f.object), 
                    method: :delete, 
                    confirm: "Bạn có chắc chắn muốn xóa ảnh chính?",
                    class: "btn btn-danger btn-sm"
          end
        end
      end
      
      # Multiple images upload
      div class: "multiple-images-upload" do
        h4 "📷 Upload nhiều ảnh bổ sung"
        
        f.input :images, label: false, as: :file,
                hint: raw("
                  <div class='upload-hint'>
                    <strong>💡 Hướng dẫn:</strong><br>
                    🔹 Giữ <kbd>Ctrl</kbd> (Windows) hoặc <kbd>Cmd</kbd> (Mac) để chọn nhiều ảnh<br>
                    🔹 Hoặc kéo thả nhiều file vào khung upload<br>
                    🔹 Định dạng: JPG, PNG, GIF | Kích thước: tối đa 5MB/ảnh<br>
                    🔹 Khuyến nghị: 600x600px trở lên cho chất lượng tốt nhất
                  </div>
                "),
                input_html: { 
                  multiple: true, 
                  accept: 'image/*',
                  title: "Chọn nhiều ảnh để upload cùng lúc",
                  id: 'multiple_images_input'
                }
        
        # Preview container for multiple images
        div id: "multiple_images_preview", class: "multiple-images-preview", style: "display: none; margin: 15px 0; padding: 15px; background: #f8f9fa; border-radius: 8px; border: 1px solid #dee2e6;" do
          h4 "Preview ảnh bổ sung mới:"
          div id: "multiple_images_preview_container", class: "gallery-grid", style: "gap: 10px;"
        end
        
        # JavaScript để hiển thị preview ảnh
        script do
          raw("
            document.addEventListener('DOMContentLoaded', function() {
              
              // Preview for main image
              const mainImageInput = document.getElementById('main_image_input');
              if (mainImageInput) {
                mainImageInput.addEventListener('change', function(e) {
                  const file = e.target.files[0];
                  const preview = document.getElementById('main_image_preview');
                  const container = document.getElementById('main_image_preview_container');
                  
                  if (file && file.type.startsWith('image/')) {
                    const reader = new FileReader();
                    reader.onload = function(e) {
                      container.innerHTML = '<img src=\"' + e.target.result + '\" style=\"width: 250px; height: 250px; object-fit: cover; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.2);\" />';
                      preview.style.display = 'block';
                    };
                    reader.readAsDataURL(file);
                  } else {
                    preview.style.display = 'none';
                    container.innerHTML = '';
                  }
                });
              }
              
              // Preview for multiple images
              const multipleImagesInput = document.getElementById('multiple_images_input');
              if (multipleImagesInput) {
                multipleImagesInput.addEventListener('change', function(e) {
                  const files = e.target.files;
                  const preview = document.getElementById('multiple_images_preview');
                  const container = document.getElementById('multiple_images_preview_container');
                  
                  if (files.length > 0) {
                    let html = '';
                    let loadedCount = 0;
                    
                    for (let i = 0; i < files.length; i++) {
                      if (files[i].type.startsWith('image/')) {
                        const reader = new FileReader();
                        reader.onload = function(e) {
                          html += '<div class=\"gallery-item\" style=\"text-align: center; padding: 10px; background: white; border-radius: 6px; border: 1px solid #dee2e6;\">' +
                                  '<img src=\"' + e.target.result + '\" style=\"width: 120px; height: 120px; object-fit: cover; border-radius: 4px;\" />' +
                                  '<div style=\"margin-top: 5px; font-size: 12px; color: #666;\">Ảnh #' + (loadedCount + 1) + '</div>' +
                                  '</div>';
                          loadedCount++;
                          
                          if (loadedCount === files.length) {
                            container.innerHTML = html;
                            preview.style.display = 'block';
                          }
                        };
                        reader.readAsDataURL(files[i]);
                      }
                    }
                  } else {
                    preview.style.display = 'none';
                    container.innerHTML = '';
                  }
                });
              }
              
            });
          ")
        end
      end
      
      # Hiển thị ảnh bổ sung hiện tại - same style as show page
      if f.object.persisted? && f.object.safe_images.any?
        div class: "gallery-images-show" do
          h3 "Ảnh bổ sung:"
          div class: "gallery-grid" do
            f.object.safe_images.each_with_index do |image, index|
              if image.present?
                div class: "gallery-item" do
                  div class: "item-meta" do
                    div class: "main-image-container" do
                      image_tag image.url(:small), style: "width: 180px; height: 180px; object-fit: cover; border-radius: 6px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);"
                    end
                    div class: "item-meta" do
                      span "Vị trí: #{index + 1} | "
                      span "Kích hoạt", class: "status_tag ok"
                    end
                  end
                end
              end
            end
          end
        end
      end
    end

    # Description management panel - same style as show page
    panel "Mô tả chi tiết" do
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

    # Specifications management panel - same style as show page
    panel "Thông số kỹ thuật" do
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
        if product.persisted? && product.main_image.present?
          image_tag product.main_image.url(:medium), style: "width: 200px; height: 200px; object-fit: cover;"
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
        if resource.persisted? && resource.main_image.present?
          div class: "main-image-show" do
            h3 "Ảnh chính:"
            div class: "main-image-container" do
              image_tag resource.main_image.url(:large), style: "width: 250px; height: 250px; object-fit: cover; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.2);"
            end
          end
        end
        
        if resource.safe_images.any?
          div class: "gallery-images-show" do
            h3 "Ảnh bổ sung:"
            div class: "gallery-grid" do
              resource.safe_images.each_with_index do |image, index|
                if image.present?
                  div class: "gallery-item" do
                    div class: "item-meta" do
                      div class: "main-image-container" do
                        image_tag image.url(:small), style: "width: 180px; height: 180px; object-fit: cover; border-radius: 6px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);"
                      end
                      div class: "item-meta" do
                        span "Vị trí: #{index + 1} | "
                        span "Kích hoạt", class: "status_tag ok"
                      end
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
    if resource.main_image.present?
      resource.remove_main_image!
      resource.save
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
      li "Sản phẩm có ảnh: #{Product.where('main_image IS NOT NULL OR images IS NOT NULL AND JSON_LENGTH(images) > 0').count}"
      li "Sản phẩm có mô tả: #{Product.joins(:product_descriptions).distinct.count}"
      li "Sản phẩm có thông số: #{Product.joins(:product_specifications).distinct.count}"
    end
  end

  # Controller để xử lý upload ảnh và nested attributes
  controller do
    def create
      # Debug logging
      Rails.logger.info "Creating product with params: #{permitted_params[:product].inspect}"
      
      @product = Product.new(permitted_params[:product])
      
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
      
      # Handle images separately to preserve existing images
      product_params = permitted_params[:product]
      
      # If new images are being uploaded, append to existing images instead of replacing
      if product_params[:images].present? && product_params[:images].any?(&:present?)
        new_images = product_params[:images].reject(&:blank?)
        existing_images = @product.images || []
        
        # Combine existing and new images
        combined_images = existing_images + new_images
        product_params[:images] = combined_images
        
        Rails.logger.info "Combined images: existing=#{existing_images.count}, new=#{new_images.count}, total=#{combined_images.count}"
      elsif product_params[:images].present? && product_params[:images].all?(&:blank?)
        # If images field is present but all blank, remove it from params to preserve existing images
        product_params.delete(:images)
        Rails.logger.info "Removed blank images from params to preserve existing images"
      end
      
      if @product.update(product_params)
        redirect_to resource_path(@product), notice: "Đã cập nhật sản phẩm thành công"
      else
        Rails.logger.error "Failed to update product: #{@product.errors.full_messages}"
        render :edit
      end
    end
  end




end
