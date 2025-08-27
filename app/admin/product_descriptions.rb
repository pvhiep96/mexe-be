ActiveAdmin.register ProductDescription do
  permit_params :product_id, :title, :content, :position, :is_active

  menu label: "Mô tả sản phẩm"

  index do
    selectable_column
    id_column
    column "Sản phẩm", :product
    column "Tiêu đề", :title
    column "Vị trí", :position
    column "Kích hoạt", :is_active
    column "Ngày tạo", :created_at
    actions
  end

  filter :product
  filter :title
  filter :position
  filter :is_active
  filter :created_at

  form do |f|
    f.inputs "Thông tin mô tả sản phẩm" do
      if params[:product_id].present?
        f.input :product_id, as: :hidden, input_html: { value: params[:product_id] }
        product = Product.find(params[:product_id])
        div class: "selected-product" do
          h3 "Sản phẩm: #{product.name} (#{product.sku})"
        end
      else
        f.input :product, label: "Sản phẩm"
      end
      f.input :title, label: "Tiêu đề"
      f.input :content, label: "Nội dung", as: :text, input_html: { class: 'ckeditor', rows: 10 }
      f.input :position, label: "Vị trí (số càng nhỏ càng hiển thị trước)"
      f.input :is_active, label: "Kích hoạt"
    end
    f.actions
  end

  show do
    attributes_table do
      row "ID", :id
      row "Sản phẩm", :product
      row "Tiêu đề", :title
      row "Nội dung" do |description|
        simple_format(description.content)
      end
      row "Vị trí", :position
      row "Kích hoạt", :is_active
      row "Ngày tạo", :created_at
      row "Ngày cập nhật", :updated_at
    end

    panel "Thông tin sản phẩm" do
      attributes_table_for resource.product do
        row "Tên sản phẩm", :name
        row "Mã SKU", :sku
        row "Thương hiệu", :brand
        row "Danh mục", :category
        row "Giá", :price do |product|
          number_to_currency(product.price, unit: "₫", precision: 0)
        end
      end
    end
  end

  # Sidebar thống kê
  sidebar "Thống kê mô tả", only: :index do
    ul do
      li "Tổng số mô tả: #{ProductDescription.count}"
      li "Mô tả kích hoạt: #{ProductDescription.where(is_active: true).count}"
      li "Sản phẩm có mô tả: #{Product.joins(:product_descriptions).distinct.count}"
    end
  end

  # Batch actions
  batch_action :activate, confirm: "Bạn có chắc muốn kích hoạt các mô tả đã chọn?" do |ids|
    ProductDescription.where(id: ids).update_all(is_active: true)
    redirect_to collection_path, notice: "Đã kích hoạt #{ids.count} mô tả"
  end

  batch_action :deactivate, confirm: "Bạn có chắc muốn vô hiệu hóa các mô tả đã chọn?" do |ids|
    ProductDescription.where(id: ids).update_all(is_active: false)
    redirect_to collection_path, notice: "Đã vô hiệu hóa #{ids.count} mô tả"
  end

  # Member actions
  member_action :duplicate, method: :post do
    new_description = resource.dup
    new_description.title = "#{resource.title} (Copy)"
    new_description.position = ProductDescription.maximum(:position).to_i + 1
    new_description.save
    redirect_to resource_path(new_description), notice: "Đã tạo bản sao mô tả"
  end

  action_item :duplicate, only: :show do
    link_to "Tạo bản sao", duplicate_admin_product_description_path(resource), method: :post
  end

  action_item :back_to_product, only: :show do
    link_to "Quay lại sản phẩm", admin_product_path(resource.product)
  end

  # Controller để xử lý tự động điền product_id
  controller do
    def new
      @product_description = ProductDescription.new
      if params[:product_id].present?
        @product_description.product_id = params[:product_id]
      end
    end

    def create
      @product_description = ProductDescription.new(permitted_params[:product_description])
      if @product_description.save
        if params[:product_id].present?
          redirect_to admin_product_path(params[:product_id]), notice: "Đã tạo mô tả thành công"
        else
          redirect_to resource_path(@product_description), notice: "Đã tạo mô tả thành công"
        end
      else
        render :new
      end
    end
  end
end
