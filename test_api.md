# API Authentication Test Guide

## Base URL
```
http://localhost:3000/api/v1/auth
```

## 1. Đăng ký (Register)
```bash
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "full_name": "Nguyễn Văn Test",
    "phone": "0123456789",
    "password": "123456",
    "password_confirmation": "123456"
  }'
```

## 2. Đăng nhập (Login)
```bash
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "123456"
  }'
```

## 3. Xem thông tin profile (cần token)
```bash
curl -X GET http://localhost:3000/api/v1/auth/profile \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

## 4. Đổi mật khẩu (cần token)
```bash
curl -X POST http://localhost:3000/api/v1/auth/change_password \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -d '{
    "current_password": "123456",
    "new_password": "newpassword123",
    "new_password_confirmation": "newpassword123"
  }'
```

## Response Format
Tất cả API đều trả về JSON với format:
```json
{
  "success": true/false,
  "message": "Thông báo",
  "data": {
    // Dữ liệu trả về
  },
  "errors": [
    // Lỗi validation (nếu có)
  ]
}
```

## Lưu ý
- Token có hiệu lực trong 24 giờ
- Mật khẩu phải có ít nhất 6 ký tự
- Email phải có format hợp lệ
- Số điện thoại phải có format Việt Nam (bắt đầu bằng 0 hoặc +84) 