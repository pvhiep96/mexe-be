ActiveAdmin.register ProductVariant do
  permit_params :product_id, :variant_name, :variant_value, :price_adjustment, :stock_quantity, :sku

  menu label: "Biến thể sản phẩm"

  index do
    selectable_column
    id_column
    column "Sản phẩm", :product
    column "Tên biến thể", :variant_name
    column "Giá trị biến thể", :variant_value
    column "Điều chỉnh giá", :price_adjustment do |variant|
      if variant.price_adjustment > 0
        "+#{number_to_currency(variant.price_adjustment, unit: "₫", precision: 0)}"
      elsif variant.price_adjustment < 0
        "#{number_to_currency(variant.price_adjustment, unit: "₫", precision: 0)}"
      else
        "Không thay đổi"
      end
    end
    column "Giá cuối cùng", :price do |variant|
      number_to_currency(variant.price, unit: "₫", precision: 0)
    end
    column "Số lượng tồn kho", :stock_quantity
    column "Mã SKU", :sku
    column "Trạng thái" do |variant|
      if variant.is_active
        span "Có hàng", class: "status_tag ok"
      else
        span "Hết hàng", class: "status_tag error"
      end
    end
    column "Ngày tạo", :created_at
    actions
  end

  filter :product
  filter :variant_name
  filter :variant_value
  filter :price_adjustment
  filter :stock_quantity
  filter :sku
  filter :created_at

  form do |f|
    f.inputs "Thông tin biến thể sản phẩm" do
      f.input :product, label: "Sản phẩm"
      f.input :variant_name, label: "Tên biến thể (VD: Kích thước, Màu sắc)"
      f.input :variant_value, label: "Giá trị biến thể (VD: S, M, L hoặc Đỏ, Xanh)"
      f.input :price_adjustment, label: "Điều chỉnh giá (+ để tăng, - để giảm)"
      f.input :stock_quantity, label: "Số lượng tồn kho"
      f.input :sku, label: "Mã SKU (tùy chọn)"
    end
    f.actions
  end

  show do
    attributes_table do
      row "ID", :id
      row "Sản phẩm", :product
      row "Tên biến thể", :variant_name
      row "Giá trị biến thể", :variant_value
      row "Điều chỉnh giá", :price_adjustment do |variant|
        if variant.price_adjustment > 0
          "+#{number_to_currency(variant.price_adjustment, unit: "₫", precision: 0)}"
        elsif variant.price_adjustment < 0
          "#{number_to_currency(variant.price_adjustment, unit: "₫", precision: 0)}"
        else
          "Không thay đổi"
        end
      end
      row "Giá cuối cùng", :price do |variant|
        number_to_currency(variant.price, unit: "₫", precision: 0)
      end
      row "Số lượng tồn kho", :stock_quantity
      row "Mã SKU", :sku
      row "Trạng thái" do |variant|
        if variant.is_active
          span "Có hàng", class: "status_tag ok"
        else
          span "Hết hàng", class: "status_tag error"
        end
      end
      row "Ngày tạo", :created_at
      row "Ngày cập nhật", :updated_at
    end

    panel "Thông tin sản phẩm gốc" do
      attributes_table_for resource.product do
        row "Tên sản phẩm", :name
        row "Giá cơ bản", :price do |product|
          number_to_currency(product.price, unit: "₫", precision: 0)
        end
        row "Danh mục", :category
        row "Thương hiệu", :brand
        row "Trạng thái" do |product|
          if product.is_active
            span "Kích hoạt", class: "status_tag ok"
          else
            span "Không kích hoạt", class: "status_tag error"
          end
        end
      end
    end
  end

  sidebar "Thống kê biến thể", only: :index do
    ul do
      li "Tổng số biến thể: #{ProductVariant.count}"
      li "Biến thể có giá tăng: #{ProductVariant.where('price_adjustment > 0').count}"
      li "Biến thể có giá giảm: #{ProductVariant.where('price_adjustment < 0').count}"
      li "Biến thể hết hàng: #{ProductVariant.where(stock_quantity: 0).count}"
    end
  end

  # Batch actions
  batch_action :update_stock, form: {
    stock_quantity: 'number'
  } do |ids, inputs|
    ProductVariant.where(id: ids).update_all(stock_quantity: inputs[:stock_quantity])
    redirect_to collection_path, notice: "Đã cập nhật số lượng tồn kho cho #{ids.count} biến thể"
  end

  # Member actions
  member_action :duplicate, method: :post do
    new_variant = resource.dup
    new_variant.variant_name = "#{resource.variant_name} (Copy)"
    new_variant.save
    redirect_to resource_path(new_variant), notice: "Đã tạo bản sao biến thể"
  end

  action_item :duplicate, only: :show do
    link_to "Tạo bản sao", duplicate_admin_product_variant_path(resource), method: :post
  end
end
