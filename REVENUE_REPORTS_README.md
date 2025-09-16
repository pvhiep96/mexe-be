# Hệ thống Báo cáo Doanh thu & Lợi nhuận

## Tổng quan

Hệ thống báo cáo doanh thu và lợi nhuận cho phép:
- **Client**: Xem báo cáo doanh thu và lợi nhuận của chính mình
- **Super Admin**: Xem báo cáo doanh thu và lợi nhuận của tất cả clients

## Tính năng chính

### 1. Báo cáo theo kỳ
- **Hàng ngày**: Báo cáo doanh thu theo ngày
- **Hàng tháng**: Báo cáo doanh thu theo tháng
- **Hàng năm**: Báo cáo doanh thu theo năm

### 2. Chỉ số báo cáo
- **Doanh thu**: Tổng doanh thu từ các đơn hàng
- **Lợi nhuận**: Lợi nhuận ước tính (mặc định 30% doanh thu)
- **Số đơn hàng**: Tổng số đơn hàng
- **Sản phẩm bán**: Tổng số lượng sản phẩm bán được
- **Giá trị đơn hàng trung bình**: Doanh thu / Số đơn hàng
- **Tỷ lệ lợi nhuận**: (Lợi nhuận / Doanh thu) * 100%

### 3. Phân quyền
- **Client**: Chỉ xem được báo cáo của chính mình
- **Super Admin**: Xem được báo cáo của tất cả clients

## Cấu trúc Database

### Bảng `revenue_reports`
```sql
CREATE TABLE revenue_reports (
  id BIGINT PRIMARY KEY,
  client_id BIGINT NOT NULL,
  report_date DATE NOT NULL,
  report_type VARCHAR NOT NULL,
  total_revenue DECIMAL(15,2) DEFAULT 0.0,
  total_profit DECIMAL(15,2) DEFAULT 0.0,
  order_count INTEGER DEFAULT 0,
  product_count INTEGER DEFAULT 0,
  average_order_value DECIMAL(15,2) DEFAULT 0.0,
  profit_margin DECIMAL(5,2) DEFAULT 0.0,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  FOREIGN KEY (client_id) REFERENCES admin_users(id)
);
```

## API Endpoints

### Admin API (Yêu cầu authentication)

#### 1. Lấy danh sách báo cáo
```
GET /api/v1/revenue_reports
```

**Parameters:**
- `period`: daily, monthly, yearly (default: daily)
- `start_date`: Ngày bắt đầu (YYYY-MM-DD)
- `end_date`: Ngày kết thúc (YYYY-MM-DD)
- `client_id`: ID của client (chỉ Super Admin)

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "client_id": 1,
      "report_date": "2024-01-15",
      "report_type": "daily",
      "total_revenue": 1000000,
      "total_profit": 300000,
      "order_count": 5,
      "product_count": 10,
      "average_order_value": 200000,
      "profit_margin": 30.0,
      "client_name": "Client ABC"
    }
  ]
}
```

#### 2. Lấy tổng quan báo cáo
```
GET /api/v1/revenue_reports/summary
```

**Response:**
```json
{
  "success": true,
  "data": {
    "total_revenue": 5000000,
    "total_profit": 1500000,
    "total_orders": 25,
    "total_products_sold": 50,
    "average_order_value": 200000,
    "average_profit_margin": 30.0,
    "report_count": 7
  }
}
```

#### 3. Lấy xu hướng doanh thu
```
GET /api/v1/revenue_reports/trends
```

**Parameters:**
- `period`: daily, monthly, yearly (default: monthly)
- `months`: Số tháng cần lấy (default: 12)
- `client_id`: ID của client (chỉ Super Admin)

#### 4. Lấy top clients (chỉ Super Admin)
```
GET /api/v1/revenue_reports/top_clients
```

**Parameters:**
- `limit`: Số lượng clients (default: 10)
- `start_date`: Ngày bắt đầu
- `end_date`: Ngày kết thúc

#### 5. Tạo báo cáo mới
```
POST /api/v1/revenue_reports/generate
```

**Parameters:**
- `period`: daily, monthly, yearly
- `date`: Ngày tạo báo cáo (cho daily)
- `year`: Năm (cho monthly/yearly)
- `month`: Tháng (cho monthly)
- `client_id`: ID của client (chỉ Super Admin)

### Admin Authentication

#### Đăng nhập Admin
```
POST /api/v1/admin_auth/login
```

**Body:**
```json
{
  "email": "admin@example.com",
  "password": "password"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "token": "jwt_token_here",
    "admin_user": {
      "id": 1,
      "email": "admin@example.com",
      "role": "super_admin",
      "client_name": null,
      "display_name": "Super Admin - admin@example.com"
    }
  }
}
```

#### Lấy thông tin profile
```
GET /api/v1/admin_auth/profile
```

**Headers:**
```
Authorization: Bearer jwt_token_here
```

## Admin Dashboard

### Super Admin Dashboard
- **URL**: `/admin/revenue_reports`
- **Tính năng**:
  - Xem báo cáo tất cả clients
  - Lọc theo client, kỳ báo cáo, ngày
  - Tổng quan doanh thu
  - Top clients
  - Xuất báo cáo

### Client Dashboard
- **URL**: `/admin/revenue_reports/client_dashboard`
- **Tính năng**:
  - Xem báo cáo riêng của client
  - Thống kê hôm nay
  - Biểu đồ doanh thu
  - Hiệu suất trung bình

## Tự động tạo báo cáo

### Rake Tasks

#### 1. Tạo báo cáo hàng ngày
```bash
rails revenue_reports:generate_daily
# Hoặc cho ngày cụ thể
DATE=2024-01-15 rails revenue_reports:generate_daily
```

#### 2. Tạo báo cáo hàng tháng
```bash
rails revenue_reports:generate_monthly
# Hoặc cho tháng cụ thể
YEAR=2024 MONTH=1 rails revenue_reports:generate_monthly
```

#### 3. Tạo báo cáo hàng năm
```bash
rails revenue_reports:generate_yearly
# Hoặc cho năm cụ thể
YEAR=2024 rails revenue_reports:generate_yearly
```

#### 4. Tạo tất cả báo cáo thiếu
```bash
rails revenue_reports:generate_missing
```

#### 5. Tạo báo cáo cho client cụ thể
```bash
CLIENT_ID=1 rails revenue_reports:generate_for_client
```

#### 6. Xem thống kê báo cáo
```bash
rails revenue_reports:stats
```

### Background Jobs

Hệ thống tự động tạo báo cáo thông qua background jobs:
- **Hàng ngày**: 1:00 AM
- **Hàng tháng**: 2:00 AM (ngày 1)
- **Hàng năm**: 3:00 AM (1/1)

## Cấu hình

### Environment Variables
```bash
# Database
DATABASE_HOST=localhost
DATABASE_PORT=3306
DATABASE_USER=root
DATABASE_PASSWORD=password

# JWT Secret
SECRET_KEY_BASE=your_secret_key_here
```

### Docker Setup
```bash
# Khởi động database
docker-compose up -d db

# Chạy migration
docker-compose exec web rails db:migrate

# Tạo báo cáo mẫu
docker-compose exec web rails revenue_reports:generate_missing
```

## Sử dụng

### 1. Tạo báo cáo ban đầu
```bash
# Tạo báo cáo cho 30 ngày qua
rails revenue_reports:generate_missing
```

### 2. Xem báo cáo qua API
```bash
# Đăng nhập để lấy token
curl -X POST http://localhost:3005/api/v1/admin_auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@example.com","password":"password"}'

# Xem báo cáo
curl -X GET "http://localhost:3005/api/v1/revenue_reports?period=daily" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### 3. Xem dashboard
- Truy cập: `http://localhost:3005/admin/revenue_reports`
- Đăng nhập với tài khoản admin
- Chọn kỳ báo cáo và lọc dữ liệu

## Lưu ý

1. **Tính toán lợi nhuận**: Hiện tại sử dụng tỷ lệ cố định 30%. Có thể tùy chỉnh trong `RevenueReportService`.

2. **Trạng thái đơn hàng**: Chỉ tính các đơn hàng có trạng thái: confirmed, processing, shipped, delivered.

3. **Performance**: Báo cáo được cache và chỉ tạo lại khi cần thiết.

4. **Security**: Tất cả API đều yêu cầu authentication và phân quyền phù hợp.

## Troubleshooting

### Lỗi kết nối database
```bash
# Kiểm tra container
docker ps

# Khởi động lại database
docker-compose restart db
```

### Lỗi migration
```bash
# Chạy migration trong container
docker-compose exec web rails db:migrate
```

### Lỗi tạo báo cáo
```bash
# Kiểm tra logs
docker-compose logs web

# Tạo báo cáo thủ công
docker-compose exec web rails revenue_reports:generate_daily
```


