# Admin CRUD Features - Super Admin Quản lý Tài khoản

## Tổng quan
Super Admin có thể thực hiện đầy đủ các thao tác CRUD (Create, Read, Update, Delete) với tài khoản Client và Super Admin khác.

## 1. Create (Tạo mới)

### 1.1 Tạo tài khoản Super Admin
- **Route**: `POST /admin/admin_users`
- **Form**: `/admin/admin_users/new`
- **Tính năng**:
  - Tạo tài khoản Super Admin mới
  - Tự động tạo mật khẩu ngẫu nhiên
  - Không cần thông tin NPP

### 1.2 Tạo tài khoản NPP (Client)
- **Route**: `POST /admin/admin_users`
- **Form**: `/admin/admin_users/new`
- **Tính năng**:
  - Tạo tài khoản NPP mới
  - Bắt buộc nhập thông tin công ty
  - Tự động tạo mật khẩu ngẫu nhiên
  - Validation đầy đủ

### 1.3 Form Fields
```ruby
# Thông tin cơ bản
- email (required)
- role (required): super_admin hoặc client
- password (optional): để trống để tự tạo
- password_confirmation (optional)

# Thông tin NPP (chỉ khi role = client)
- client_name (required)
- client_phone (required)
- client_address (optional)
```

## 2. Read (Xem)

### 2.1 Danh sách tài khoản
- **Route**: `GET /admin/admin_users`
- **View**: `/admin/admin_users/index`
- **Tính năng**:
  - Hiển thị tất cả tài khoản
  - Phân trang (20 tài khoản/trang)
  - Tìm kiếm theo email
  - Lọc theo loại tài khoản
  - Thống kê sản phẩm và đơn hàng

### 2.2 Chi tiết tài khoản
- **Route**: `GET /admin/admin_users/:id`
- **View**: `/admin/admin_users/show`
- **Tính năng**:
  - Thông tin đầy đủ tài khoản
  - Thống kê hoạt động
  - Sản phẩm gần đây
  - Các thao tác có thể thực hiện

### 2.3 Thông tin hiển thị
```ruby
# Thông tin cơ bản
- Email
- Loại tài khoản (Super Admin/NPP)
- Ngày tạo
- Cập nhật lần cuối

# Thông tin NPP
- Tên công ty
- Điện thoại
- Địa chỉ

# Thống kê
- Số sản phẩm
- Số đơn hàng
- Sản phẩm gần đây
```

## 3. Update (Cập nhật)

### 3.1 Chỉnh sửa thông tin
- **Route**: `PATCH /admin/admin_users/:id`
- **Form**: `/admin/admin_users/edit`
- **Tính năng**:
  - Cập nhật email
  - Thay đổi loại tài khoản
  - Cập nhật thông tin NPP
  - Đổi mật khẩu (tùy chọn)

### 3.2 Đặt lại mật khẩu
- **Route**: `PATCH /admin/admin_users/:id/reset_password`
- **Tính năng**:
  - Tự động tạo mật khẩu mới
  - Hiển thị mật khẩu mới cho Super Admin
  - Không thể đặt lại mật khẩu của chính mình

### 3.3 Validation
```ruby
# Email validation
- Format hợp lệ
- Unique trong hệ thống

# Password validation
- Tối thiểu 6 ký tự
- Xác nhận mật khẩu khớp nhau

# NPP validation
- client_name required khi role = client
- client_phone required khi role = client
```

## 4. Delete (Xóa)

### 4.1 Xóa tài khoản
- **Route**: `DELETE /admin/admin_users/:id`
- **Tính năng**:
  - Xóa tài khoản khỏi hệ thống
  - Không thể xóa tài khoản hiện tại
  - Xác nhận trước khi xóa
  - Xóa tất cả dữ liệu liên quan

### 4.2 Bảo mật
- Không cho phép xóa tài khoản đang đăng nhập
- Xác nhận trước khi xóa
- Hiển thị cảnh báo rõ ràng

## 5. Additional Features

### 5.1 Grant/Revoke Access
- **Route**: `PATCH /admin/admin_users/:id/grant_access`
- **Route**: `PATCH /admin/admin_users/:id/revoke_access`
- **Tính năng**:
  - Cấp quyền truy cập
  - Thu hồi quyền truy cập
  - Có thể mở rộng thêm logic

### 5.2 Search & Filter
- **Tìm kiếm theo email**: Sử dụng Ransack
- **Lọc theo role**: Super Admin hoặc NPP
- **Phân trang**: 20 tài khoản/trang

### 5.3 Responsive Design
- **Mobile-friendly**: Tương thích mobile
- **Grid layout**: Responsive grid system
- **Touch-friendly**: Buttons và forms dễ sử dụng

## 6. Security Features

### 6.1 Authorization
```ruby
# Chỉ Super Admin mới có quyền
before_action :ensure_super_admin

def ensure_super_admin
  unless current_admin_user&.super_admin?
    redirect_to admin_root_path, alert: "Chỉ Super Admin mới có quyền quản lý tài khoản NPP"
  end
end
```

### 6.2 Data Protection
- Không hiển thị mật khẩu trong form
- Validation đầy đủ
- CSRF protection
- XSS protection

### 6.3 Business Rules
- Không thể xóa tài khoản hiện tại
- Không thể đặt lại mật khẩu của chính mình
- Validation role-specific fields

## 7. UI/UX Features

### 7.1 Dashboard Integration
- Link "Quản lý tài khoản" trong dashboard
- Chỉ hiển thị cho Super Admin
- Quick access từ main menu

### 7.2 Form Experience
- **Dynamic form**: Hiện/ẩn fields theo role
- **Real-time validation**: Client-side validation
- **Clear feedback**: Error messages rõ ràng
- **Auto-save**: Có thể thêm tính năng auto-save

### 7.3 Table Features
- **Sortable columns**: Sắp xếp theo cột
- **Search**: Tìm kiếm real-time
- **Pagination**: Phân trang mượt mà
- **Bulk actions**: Có thể thêm bulk operations

## 8. API Endpoints

### 8.1 RESTful Routes
```ruby
GET    /admin/admin_users           # index
GET    /admin/admin_users/new       # new
POST   /admin/admin_users           # create
GET    /admin/admin_users/:id       # show
GET    /admin/admin_users/:id/edit  # edit
PATCH  /admin/admin_users/:id       # update
DELETE /admin/admin_users/:id       # destroy

# Custom actions
PATCH  /admin/admin_users/:id/grant_access     # grant access
PATCH  /admin/admin_users/:id/revoke_access    # revoke access
PATCH  /admin/admin_users/:id/reset_password   # reset password
```

### 8.2 Response Format
```json
# Success response
{
  "status": "success",
  "message": "Đã tạo tài khoản thành công",
  "data": {
    "id": 1,
    "email": "npp@example.com",
    "role": "client",
    "client_name": "Công ty ABC"
  }
}

# Error response
{
  "status": "error",
  "message": "Có lỗi xảy ra",
  "errors": {
    "email": ["has already been taken"],
    "client_name": ["can't be blank"]
  }
}
```

## 9. Testing

### 9.1 Unit Tests
```ruby
# Test model validations
test "should create admin user with valid attributes"
test "should not create admin user without email"
test "should require client_name for client role"

# Test controller actions
test "should create admin user"
test "should update admin user"
test "should delete admin user"
test "should not delete current user"
```

### 9.2 Integration Tests
```ruby
# Test full workflow
test "should create and manage admin user"
test "should handle role changes"
test "should validate permissions"
```

## 10. Performance Considerations

### 10.1 Database Optimization
- **Indexes**: Email, role, created_at
- **Eager loading**: Includes related data
- **Pagination**: Limit records per page

### 10.2 Caching
- **Page caching**: Static content
- **Fragment caching**: Partial views
- **Query caching**: Database queries

## 11. Future Enhancements

### 11.1 Advanced Features
- **Bulk operations**: Xóa/chỉnh sửa nhiều tài khoản
- **Import/Export**: CSV import/export
- **Audit trail**: Theo dõi thay đổi
- **Email notifications**: Thông báo qua email

### 11.2 Integration
- **LDAP integration**: Đồng bộ với LDAP
- **SSO**: Single Sign-On
- **API**: RESTful API cho mobile

## Kết luận

Hệ thống CRUD cho quản lý tài khoản đã được implement đầy đủ với:
- ✅ **Create**: Tạo tài khoản Super Admin và NPP
- ✅ **Read**: Xem danh sách và chi tiết tài khoản
- ✅ **Update**: Chỉnh sửa thông tin và đặt lại mật khẩu
- ✅ **Delete**: Xóa tài khoản (với bảo mật)
- ✅ **Security**: Authorization và validation đầy đủ
- ✅ **UI/UX**: Giao diện thân thiện và responsive
- ✅ **Performance**: Tối ưu hóa database và caching

Tất cả tính năng đã sẵn sàng sử dụng và có thể mở rộng thêm theo nhu cầu.
