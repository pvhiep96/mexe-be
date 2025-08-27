ActiveAdmin.register ProductSpecification do
  permit_params :product_id, :spec_name, :spec_value, :unit, :position, :is_active

  menu label: "Thông số kỹ thuật"

  index do
    selectable_column
    id_column
    column "Sản phẩm", :product
    column "Tên thông số", :spec_name
    column "Giá trị", :spec_value
    column "Đơn vị", :unit
    column "Vị trí", :position
    column "Kích hoạt", :is_active
    column "Ngày tạo", :created_at
    actions
  end

  filter :product
  filter :spec_name
  filter :spec_value
  filter :unit
  filter :position
  filter :is_active
  filter :created_at

  form do |f|
    f.inputs "Thông tin thông số kỹ thuật" do
      if params[:product_id].present?
        f.input :product_id, as: :hidden, input_html: { value: params[:product_id] }
        product = Product.find(params[:product_id])
        div class: "selected-product" do
          h3 "Sản phẩm: #{product.name} (#{product.sku})"
        end
      else
        f.input :product, label: "Sản phẩm"
      end
      f.input :spec_name, label: "Tên thông số (VD: Trọng lượng, Kích thước, Chất liệu)"
      f.input :spec_value, label: "Giá trị (VD: 500g, 10x20x30cm, Nhựa ABS)", as: :string
      f.input :unit, label: "Đơn vị (VD: g, cm, kg, inch) - tùy chọn"
      f.input :position, label: "Vị trí (số càng nhỏ càng hiển thị trước)"
      f.input :is_active, label: "Kích hoạt"
    end
    f.actions
  end

  show do
    attributes_table do
      row "ID", :id
      row "Sản phẩm", :product
      row "Tên thông số", :spec_name
      row "Giá trị", :spec_value
      row "Đơn vị", :unit
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
  sidebar "Thống kê thông số", only: :index do
    ul do
      li "Tổng số thông số: #{ProductSpecification.count}"
      li "Thông số kích hoạt: #{ProductSpecification.where(is_active: true).count}"
      li "Sản phẩm có thông số: #{Product.joins(:product_specifications).distinct.count}"
    end
  end

  # Batch actions
  batch_action :activate, confirm: "Bạn có chắc muốn kích hoạt các thông số đã chọn?" do |ids|
    ProductSpecification.where(id: ids).update_all(is_active: true)
    redirect_to collection_path, notice: "Đã kích hoạt #{ids.count} thông số"
  end

  batch_action :deactivate, confirm: "Bạn có chắc muốn vô hiệu hóa các thông số đã chọn?" do |ids|
    ProductSpecification.where(id: ids).update_all(is_active: false)
    redirect_to collection_path, notice: "Đã vô hiệu hóa #{ids.count} thông số"
  end

  # Member actions
  member_action :duplicate, method: :post do
    new_spec = resource.dup
    new_spec.spec_name = "#{resource.spec_name} (Copy)"
    new_spec.position = ProductSpecification.maximum(:position).to_i + 1
    new_spec.save
    redirect_to resource_path(new_spec), notice: "Đã tạo bản sao thông số"
  end

  action_item :duplicate, only: :show do
    link_to "Tạo bản sao", duplicate_admin_product_specification_path(resource), method: :post
  end

  action_item :back_to_product, only: :show do
    link_to "Quay lại sản phẩm", admin_product_path(resource.product)
  end

  # Controller để xử lý tự động điền product_id
  controller do
    def new
      @product_specification = ProductSpecification.new
      if params[:product_id].present?
        @product_specification.product_id = params[:product_id]
      end
    end

    def create
      @product_specification = ProductSpecification.new(permitted_params[:product_specification])
      if @product_specification.save
        if params[:product_id].present?
          redirect_to admin_product_path(params[:product_id]), notice: "Đã tạo thông số thành công"
        else
          redirect_to resource_path(@product_specification), notice: "Đã tạo thông số thành công"
        end
      else
        render :new
      end
    end
  end
end
