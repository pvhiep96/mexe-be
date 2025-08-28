# Hướng dẫn Test Admin Tiếng Việt

## Danh sách các trang admin cần test

### 1. Dashboard
- URL: `/admin`
- Kiểm tra: Tiêu đề "Bảng điều khiển"
- Kiểm tra: Text chào mừng bằng tiếng Việt

### 2. Quản trị viên (Admin Users)
- URL: `/admin/admin_users`
- Kiểm tra: Menu label "Quản trị viên"
- Kiểm tra: Form labels bằng tiếng Việt
- Kiểm tra: Table headers bằng tiếng Việt

### 3. Sản phẩm (Products)
- URL: `/admin/products`
- Kiểm tra: Menu label "Sản phẩm"
- Kiểm tra: Tất cả form labels bằng tiếng Việt
- Kiểm tra: Table headers bằng tiếng Việt
- Kiểm tra: Filter labels bằng tiếng Việt

### 4. Danh mục (Categories)
- URL: `/admin/categories`
- Kiểm tra: Menu label "Danh mục"
- Kiểm tra: Form labels bằng tiếng Việt
- Kiểm tra: Table headers bằng tiếng Việt

### 5. Thương hiệu (Brands)
- URL: `/admin/brands`
- Kiểm tra: Menu label "Thương hiệu"
- Kiểm tra: Form labels bằng tiếng Việt
- Kiểm tra: Table headers bằng tiếng Việt

### 6. Đơn hàng (Orders)
- URL: `/admin/orders`
- Kiểm tra: Menu label "Đơn hàng"
- Kiểm tra: Form labels bằng tiếng Việt
- Kiểm tra: Table headers bằng tiếng Việt
- Kiểm tra: Status options bằng tiếng Việt

### 7. Người dùng (Users)
- URL: `/admin/users`
- Kiểm tra: Menu label "Người dùng"
- Kiểm tra: Form labels bằng tiếng Việt
- Kiểm tra: Table headers bằng tiếng Việt

### 8. Bài viết (Articles)
- URL: `/admin/articles`
- Kiểm tra: Menu label "Bài viết"
- Kiểm tra: Form labels bằng tiếng Việt
- Kiểm tra: Table headers bằng tiếng Việt

### 9. Hình ảnh sản phẩm (Product Images)
- URL: `/admin/product_images`
- Kiểm tra: Menu label "Hình ảnh sản phẩm"
- Kiểm tra: Form labels bằng tiếng Việt
- Kiểm tra: Table headers bằng tiếng Việt

### 10. Biến thể sản phẩm (Product Variants)
- URL: `/admin/product_variants`
- Kiểm tra: Menu label "Biến thể sản phẩm"
- Kiểm tra: Form labels bằng tiếng Việt
- Kiểm tra: Table headers bằng tiếng Việt

### 11. Chi tiết đơn hàng (Order Items)
- URL: `/admin/order_items`
- Kiểm tra: Menu label "Chi tiết đơn hàng"
- Kiểm tra: Form labels bằng tiếng Việt
- Kiểm tra: Table headers bằng tiếng Việt

### 12. Mã giảm giá (Coupons)
- URL: `/admin/coupons`
- Kiểm tra: Menu label "Mã giảm giá"
- Kiểm tra: Form labels bằng tiếng Việt
- Kiểm tra: Table headers bằng tiếng Việt
- Kiểm tra: Discount type options bằng tiếng Việt

## Các thành phần cần kiểm tra

### Menu Navigation
- Tất cả menu items phải hiển thị bằng tiếng Việt
- Menu priority phải đúng thứ tự

### Form Fields
- Tất cả input labels phải bằng tiếng Việt
- Placeholder text phải bằng tiếng Việt
- Validation messages phải bằng tiếng Việt

### Table Headers
- Tất cả column headers phải bằng tiếng Việt
- Action buttons phải bằng tiếng Việt

### Filters
- Filter labels phải bằng tiếng Việt
- Filter options phải bằng tiếng Việt

### Messages
- Success messages phải bằng tiếng Việt
- Error messages phải bằng tiếng Việt
- Warning messages phải bằng tiếng Việt

### Pagination
- Pagination text phải bằng tiếng Việt
- "Trước", "Tiếp", "Đầu", "Cuối"

### Batch Actions
- Batch action labels phải bằng tiếng Việt
- "Chọn tất cả", "Bỏ chọn tất cả"

## Cách test

1. **Khởi động server**: `rails server`
2. **Truy cập admin**: `http://localhost:3000/admin`
3. **Đăng nhập** với tài khoản admin
4. **Kiểm tra từng trang** theo danh sách trên
5. **Test các chức năng**:
   - Tạo mới (New)
   - Chỉnh sửa (Edit)
   - Xem chi tiết (Show)
   - Xóa (Delete)
   - Filter và Search
   - Export/Import (nếu có)

## Lưu ý khi test

- Đảm bảo database có dữ liệu để test
- Kiểm tra cả giao diện desktop và mobile
- Test các trường hợp validation
- Kiểm tra format ngày giờ (dd/mm/yyyy)
- Kiểm tra format tiền tệ (₫)

## Troubleshooting

### Nếu vẫn hiển thị tiếng Anh
1. Kiểm tra file ngôn ngữ có tồn tại
2. Khởi động lại server
3. Clear cache nếu cần
4. Kiểm tra cấu hình I18n

### Nếu có lỗi syntax
1. Kiểm tra cú pháp YAML
2. Sử dụng YAML validator
3. Kiểm tra indentation
