# Admin Role Features Implementation

## Tổng quan
Hệ thống admin đã được triển khai với 2 loại tài khoản chính:
- **Super Admin**: Quản lý toàn bộ hệ thống
- **Client (NPP)**: Nhà phân phối sản phẩm

## 1. Super Admin Features

### 1.1 Quản lý tài khoản NPP
- **Tạo tài khoản NPP**: Super Admin có thể tạo tài khoản mới cho các nhà phân phối
- **Cấp quyền truy cập**: Quản lý quyền truy cập của các tài khoản NPP
- **Xem thông tin chi tiết**: Thông tin đầy đủ về từng NPP
- **Thu hồi quyền truy cập**: Có thể vô hiệu hóa tài khoản NPP

**Routes:**
- `GET /admin/admin_users` - Danh sách tài khoản NPP
- `POST /admin/admin_users` - Tạo tài khoản NPP mới
- `PATCH /admin/admin_users/:id/grant_access` - Cấp quyền truy cập
- `PATCH /admin/admin_users/:id/revoke_access` - Thu hồi quyền truy cập

### 1.2 Duyệt nội dung sản phẩm
- **Duyệt sản phẩm mới**: Khi NPP tạo sản phẩm mới, sản phẩm sẽ có `is_active = false` và cần được duyệt
- **Duyệt chỉnh sửa sản phẩm**: Khi NPP chỉnh sửa sản phẩm, cần được duyệt lại
- **Hệ thống approval**: Theo dõi trạng thái duyệt (pending, approved, rejected)
- **Lý do từ chối**: Có thể nhập lý do khi từ chối sản phẩm

**Routes:**
- `GET /admin/product_approvals` - Danh sách sản phẩm cần duyệt
- `PATCH /admin/product_approvals/:id/approve` - Duyệt sản phẩm
- `PATCH /admin/product_approvals/:id/reject` - Từ chối sản phẩm

### 1.3 Quản lý đặt hàng
- **Xem tất cả đơn hàng**: Super Admin có thể xem tất cả đơn hàng trong hệ thống
- **Cập nhật thông tin vận chuyển**: Quản lý tracking number, shipping provider
- **Theo dõi trạng thái đơn hàng**: Xem chi tiết trạng thái xử lý

**Routes:**
- `GET /admin/orders` - Danh sách đơn hàng
- `GET /admin/orders/:id` - Chi tiết đơn hàng
- `PATCH /admin/orders/:id/update_shipping` - Cập nhật thông tin vận chuyển

### 1.4 Báo cáo doanh thu
- **Doanh thu tổng quan**: Tổng doanh thu của toàn bộ website
- **Doanh thu theo NPP**: Phân tích doanh thu từng nhà phân phối
- **Doanh thu theo tháng**: Biểu đồ doanh thu theo thời gian
- **Sản phẩm bán chạy**: Top sản phẩm có doanh số cao nhất
- **Chi tiết NPP**: Xem báo cáo chi tiết của từng NPP

**Routes:**
- `GET /admin/analytics` - Báo cáo tổng quan
- `GET /admin/analytics/npp/:npp_id` - Chi tiết doanh thu NPP

## 2. Client (NPP) Features

### 2.1 Quản lý sản phẩm
- **Tạo sản phẩm mới**: Sản phẩm được tạo với `is_active = false` mặc định
- **Chỉnh sửa sản phẩm**: Có thể chỉnh sửa sản phẩm của mình
- **Xem sản phẩm**: Chỉ xem được sản phẩm của mình
- **Trạng thái sản phẩm**: Theo dõi trạng thái duyệt sản phẩm

**Workflow:**
1. Client tạo sản phẩm → `is_active = false`
2. Hệ thống tự động tạo ProductApproval với status = pending
3. Super Admin duyệt → `is_active = true`
4. Sản phẩm hiển thị trên website

### 2.2 Quản lý đơn hàng
- **Xem đơn hàng**: Chỉ xem được đơn hàng chứa sản phẩm của mình
- **Cập nhật vận chuyển**: Có thể cập nhật thông tin vận chuyển cho đơn hàng chưa xử lý
- **Thông báo đơn hàng mới**: Nhận thông báo khi có đơn hàng mới

### 2.3 Báo cáo doanh thu
- **Doanh thu cá nhân**: Xem doanh thu từ sản phẩm của mình
- **Thống kê sản phẩm**: Số lượng sản phẩm, sản phẩm hoạt động, chờ duyệt
- **Doanh thu theo tháng**: Biểu đồ doanh thu theo thời gian
- **Hiệu suất sản phẩm**: Phân tích hiệu suất sản phẩm

**Routes:**
- `GET /admin/analytics/client` - Báo cáo doanh thu cá nhân

## 3. Database Schema

### 3.1 Product Approvals Table
```sql
CREATE TABLE product_approvals (
  id BIGINT PRIMARY KEY,
  product_id BIGINT NOT NULL,
  admin_user_id BIGINT NOT NULL,
  status INTEGER DEFAULT 0, -- pending: 0, approved: 1, rejected: 2
  reason TEXT,
  approved_at DATETIME,
  approval_type VARCHAR(255) DEFAULT 'creation', -- creation or edit
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL
);
```

### 3.2 Admin Users Table
```sql
CREATE TABLE admin_users (
  id BIGINT PRIMARY KEY,
  email VARCHAR(255) NOT NULL UNIQUE,
  encrypted_password VARCHAR(255) NOT NULL,
  role INTEGER DEFAULT 0, -- super_admin: 0, client: 1
  client_name VARCHAR(255),
  client_phone VARCHAR(255),
  client_address TEXT,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL
);
```

## 4. Authorization System

### 4.1 Role-based Access Control
- **Super Admin**: Toàn quyền truy cập tất cả tính năng
- **Client**: Chỉ truy cập được sản phẩm và đơn hàng của mình

### 4.2 Permission Methods
```ruby
# AdminUser model
def can_manage_products?
  super_admin? || client?
end

def can_manage_orders?
  super_admin? || client?
end

def can_view_analytics?
  super_admin? || client?
end

def can_approve_products?
  super_admin?
end

def can_manage_admin_users?
  super_admin?
end
```

## 5. Key Features

### 5.1 Product Approval Workflow
1. **Client tạo sản phẩm** → `is_active = false`
2. **Hệ thống tạo ProductApproval** → status = pending
3. **Super Admin duyệt** → `is_active = true`
4. **Sản phẩm hiển thị** trên website

### 5.2 Order Management
- **Super Admin**: Xem tất cả đơn hàng
- **Client**: Chỉ xem đơn hàng chứa sản phẩm của mình
- **Thông báo tự động**: Client nhận thông báo khi có đơn hàng mới

### 5.3 Revenue Analytics
- **Tổng quan**: Doanh thu tổng, sản phẩm bán chạy, đơn hàng gần đây
- **Theo NPP**: Phân tích doanh thu từng nhà phân phối
- **Cá nhân**: Client xem doanh thu của riêng mình

## 6. UI/UX Features

### 6.1 Dashboard
- **Statistics Cards**: Hiển thị số liệu quan trọng
- **Quick Actions**: Các thao tác nhanh
- **Recent Products**: Sản phẩm gần đây
- **Role-based UI**: Giao diện khác nhau cho từng role

### 6.2 Analytics Views
- **Interactive Charts**: Biểu đồ doanh thu theo tháng
- **Date Range Filter**: Lọc theo khoảng thời gian
- **Responsive Design**: Tương thích mobile
- **Real-time Data**: Dữ liệu cập nhật real-time

## 7. Security Features

### 7.1 Data Isolation
- **Client chỉ xem được dữ liệu của mình**
- **Super Admin xem được tất cả dữ liệu**
- **Authorization checks** ở mọi controller

### 7.2 Product Security
- **Client không thể thay đổi is_active**
- **Chỉ Super Admin mới có quyền duyệt sản phẩm**
- **Validation** đầy đủ cho tất cả actions

## 8. Usage Examples

### 8.1 Tạo tài khoản NPP mới
```ruby
# Super Admin tạo tài khoản NPP
admin_user = AdminUser.create!(
  email: "npp@example.com",
  role: :client,
  client_name: "Công ty ABC",
  client_phone: "0123456789",
  client_address: "123 Đường ABC, Quận 1, TP.HCM"
)
```

### 8.2 Duyệt sản phẩm
```ruby
# Super Admin duyệt sản phẩm
product_approval = ProductApproval.find(params[:id])
product_approval.approve!(current_admin_user, "Sản phẩm chất lượng tốt")
```

### 8.3 Xem doanh thu
```ruby
# Client xem doanh thu của mình
revenue = Order.joins(order_items: :product)
               .where(products: { client_id: current_admin_user.id })
               .where(orders: { status: ['delivered', 'paid'] })
               .sum('order_items.quantity * order_items.unit_price')
```

## 9. Testing

### 9.1 Unit Tests
- Test các model methods
- Test authorization logic
- Test product approval workflow

### 9.2 Integration Tests
- Test controller actions
- Test role-based access
- Test analytics calculations

## 10. Deployment Notes

### 10.1 Database Migration
```bash
rails db:migrate
```

### 10.2 Seed Data
```ruby
# Tạo Super Admin mặc định
AdminUser.create!(
  email: "admin@mexe.com",
  password: "password123",
  role: :super_admin
)
```

### 10.3 Environment Variables
```env
# Không cần thêm biến môi trường mới
# Sử dụng cấu hình hiện tại
```

## Kết luận

Hệ thống admin role đã được triển khai đầy đủ với:
- ✅ 2 loại tài khoản: Super Admin và Client
- ✅ Quản lý tài khoản NPP
- ✅ Hệ thống duyệt sản phẩm
- ✅ Quản lý đơn hàng
- ✅ Báo cáo doanh thu chi tiết
- ✅ Giao diện thân thiện
- ✅ Bảo mật dữ liệu
- ✅ Authorization đầy đủ

Tất cả các tính năng đã được implement và sẵn sàng sử dụng.
