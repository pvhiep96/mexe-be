# Admin Panel Logout Feature

## Tổng quan
Đã thêm tính năng logout vào Admin Panel với giao diện thân thiện và logic xử lý an toàn.

## Các thay đổi đã thực hiện

### 1. Giao diện (UI)
- **Vị trí**: Nút logout được thêm vào cuối sidebar, dưới nút "View Site"
- **Thiết kế**: 
  - Icon: 🚪 (cửa ra)
  - Màu sắc: Đỏ (#dc3545) để phân biệt với các nút khác
  - Hover effect: Nền đỏ với chữ trắng
- **Xác nhận**: Có popup xác nhận trước khi logout

### 2. Logic xử lý
- **Controller**: Tạo `Admin::SessionsController` tùy chỉnh
- **Routes**: Cập nhật để sử dụng controller tùy chỉnh
- **Redirect**: Sau logout sẽ redirect về trang login
- **Logging**: Ghi log khi admin logout

### 3. Thông tin người dùng
- **Hiển thị**: Email của admin đang đăng nhập
- **Phân quyền**: Hiển thị "SUPER ADMIN" nếu có quyền

## Cách sử dụng

### Đăng xuất
1. Click vào nút "🚪 Đăng xuất" ở cuối sidebar
2. Xác nhận trong popup
3. Sẽ được redirect về trang login

### Thông tin hiển thị
- Email admin hiện tại ở đầu sidebar
- Badge "SUPER ADMIN" nếu có quyền cao nhất

## Files đã thay đổi

1. `app/views/layouts/admin/application.html.erb`
   - Thêm nút logout vào sidebar
   - Thêm CSS cho nút logout
   - Hiển thị thông tin admin user

2. `app/controllers/admin/sessions_controller.rb` (mới)
   - Xử lý logic logout tùy chỉnh
   - Redirect paths
   - Logging

3. `config/routes.rb`
   - Cập nhật Devise routes để sử dụng controller tùy chỉnh

4. `Gemfile`
   - Sửa lỗi platform cho tzinfo-data

## Testing

### Kiểm tra tính năng
1. Truy cập `http://localhost:3005/admin`
2. Đăng nhập với admin account
3. Kiểm tra:
   - Thông tin admin hiển thị ở sidebar
   - Nút logout có màu đỏ
   - Click logout có popup xác nhận
   - Sau logout redirect về login page

### Logs
- Kiểm tra Rails logs để xem thông báo logout
- Format: "Admin user [email] is logging out"

## Bảo mật
- Sử dụng Devise's built-in security
- CSRF protection
- Session invalidation
- Secure redirects

## Tương lai
- Có thể thêm "Remember me" functionality
- Thêm session timeout
- Thêm audit trail cho admin actions
