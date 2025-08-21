# Hướng dẫn Admin Tiếng Việt

## Tổng quan
Đã hoàn thành việc chuyển đổi toàn bộ trang admin sang tiếng Việt.

## Các thay đổi đã thực hiện

### 1. File ngôn ngữ đã tạo
- `config/locales/active_admin.vi.yml` - Ngôn ngữ cho ActiveAdmin (đã mở rộng)
- `config/locales/models.vi.yml` - Tên tiếng Việt cho các model (đã mở rộng)
- `config/locales/devise.vi.yml` - Ngôn ngữ cho hệ thống xác thực
- `config/locales/vi.yml` - Ngôn ngữ chung cho ứng dụng

### 2. Cấu hình đã cập nhật
- `config/initializers/active_admin.rb` - Đặt ngôn ngữ mặc định là tiếng Việt
- `config/application.rb` - Cấu hình I18n và load các file ngôn ngữ

### 3. Các trang admin đã được Việt hóa
- **Dashboard** - Bảng điều khiển
- **Quản trị viên** - Admin Users
- **Sản phẩm** - Products
- **Danh mục** - Categories  
- **Thương hiệu** - Brands
- **Đơn hàng** - Orders
- **Người dùng** - Users
- **Bài viết** - Articles
- **Hình ảnh sản phẩm** - Product Images
- **Biến thể sản phẩm** - Product Variants
- **Chi tiết đơn hàng** - Order Items
- **Mã giảm giá** - Coupons

### 4. Các thành phần đã được dịch
- Menu navigation
- Form labels
- **Table headers và column names** (đã cập nhật)
- Button text
- Status options
- Error messages
- Success messages
- Validation messages
- Date/time formats
- Currency format (₫)
- **Tất cả trường trong bảng admin** (đã cập nhật)

## Cách sử dụng

### Khởi động ứng dụng
```bash
rails server
```

### Truy cập admin
- URL: `http://localhost:3000/admin`
- Tất cả giao diện sẽ hiển thị bằng tiếng Việt

### Thay đổi ngôn ngữ
Để thay đổi ngôn ngữ, có thể:
1. Thay đổi `config.i18n.default_locale` trong `config/application.rb`
2. Hoặc sử dụng tham số `locale` trong URL

## Cấu trúc file ngôn ngữ

### active_admin.vi.yml
Chứa các text cho ActiveAdmin interface

### models.vi.yml  
Chứa tên tiếng Việt cho models và attributes

### devise.vi.yml
Chứa text cho hệ thống xác thực

### vi.yml
Chứa text chung cho toàn bộ ứng dụng

## Lưu ý quan trọng

1. **Khởi động lại server**: Sau khi thay đổi cấu hình, cần khởi động lại server
2. **Cache**: Nếu sử dụng cache, có thể cần clear cache
3. **Database**: Đảm bảo database có dữ liệu để test
4. **Permissions**: Kiểm tra quyền truy cập admin
5. **Table headers**: Tất cả tên cột trong bảng đã được Việt hóa hoàn toàn

## Troubleshooting

### Nếu admin vẫn hiển thị tiếng Anh
1. Kiểm tra file `config/locales/active_admin.vi.yml` có tồn tại
2. Kiểm tra `config.i18n.default_locale = :vi` trong `application.rb`
3. Khởi động lại server

### Nếu có lỗi syntax trong file YAML
1. Kiểm tra cú pháp YAML
2. Sử dụng online YAML validator
3. Kiểm tra indentation (phải dùng spaces, không dùng tabs)

## Hỗ trợ thêm

Để thêm ngôn ngữ mới hoặc chỉnh sửa:
1. Tạo file ngôn ngữ mới trong `config/locales/`
2. Cập nhật `config.i18n.available_locales`
3. Thêm logic chuyển đổi ngôn ngữ nếu cần

## Kết luận

Tất cả các trang admin đã được chuyển đổi sang tiếng Việt hoàn chỉnh. Giao diện sẽ hiển thị bằng tiếng Việt mặc định khi truy cập `/admin`.
