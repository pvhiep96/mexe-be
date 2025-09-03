# Sửa lỗi Authentication cho API Orders

## 🛠️ Vấn đề đã sửa

### 1. **ArgumentError: Before process_action callback :authenticate_user_from_token has not been defined**

**Nguyên nhân**: `OrdersController` kế thừa từ `::Api::ApplicationController` nhưng controller này không có method `authenticate_user_from_token`.

**Giải pháp**: Đã thêm các method authentication cần thiết vào `Api::ApplicationController`:

```ruby
# app/controllers/api/application_controller.rb
module Api
  class ApplicationController < ::ApplicationController
    skip_before_action :verify_authenticity_token

    private

    def authenticate_user_from_token
      token = extract_token_from_header
      Rails.logger.debug "Auth Header Token: #{token ? 'Present' : 'Missing'}"
      return unless token
      
      user_id = JwtService.extract_user_id(token)
      Rails.logger.debug "User ID from token: #{user_id}"
      
      @current_user = User.find_by(id: user_id) if user_id
      Rails.logger.debug "Current user found: #{@current_user ? @current_user.email : 'None'}"
    end
    
    def extract_token_from_header
      auth_header = request.headers['Authorization']
      return nil unless auth_header
      
      # Extract token from "Bearer TOKEN" format
      auth_header.split(' ').last if auth_header.start_with?('Bearer ')
    end
    
    def current_user
      @current_user
    end
    
    def authenticate_user!
      unless current_user
        render json: { 
          error: 'Unauthorized',
          message: 'Vui lòng đăng nhập để tiếp tục'
        }, status: :unauthorized
      end
    end
  end
end
```

### 2. **Thêm Kaminari gem cho pagination**

**Nguyên nhân**: `OrdersController` sử dụng `.page()` method nhưng không có gem pagination.

**Giải pháp**: Đã thêm `kaminari` gem vào Gemfile:

```ruby
# Pagination
gem "kaminari"
```

## 🚀 Cách khắc phục

### Bước 1: Cài đặt gem mới
```bash
cd mexe-be
bundle install
```

### Bước 2: Restart Rails server
```bash
# Stop current server (Ctrl+C)
# Then restart
rails server
```

### Bước 3: Test API endpoint
```bash
# Test với curl (cần thay YOUR_JWT_TOKEN bằng token thực)
curl -H "Authorization: Bearer YOUR_JWT_TOKEN" \
     -H "Content-Type: application/json" \
     http://localhost:3005/api/v1/users/orders
```

## 📁 Files đã sửa

1. **`app/controllers/api/application_controller.rb`** - Thêm authentication methods
2. **`config/routes.rb`** - Sửa route mapping
3. **`app/controllers/api/v1/orders_controller.rb`** - Cải thiện authentication và response
4. **`app/serializers/order_serializer.rb`** - Thêm fields cần thiết
5. **`app/serializers/order_item_serializer.rb`** - Thêm aliases cho frontend
6. **`Gemfile`** - Thêm kaminari gem

## ✅ Kết quả mong đợi

Sau khi thực hiện các bước trên:
- ✅ API `/api/v1/users/orders` hoạt động không lỗi
- ✅ Authentication được xử lý đúng
- ✅ Response format phù hợp với frontend
- ✅ Pagination hoạt động với kaminari

## 🔍 Debug

Nếu vẫn có lỗi, có thể test với debug endpoint:
```bash
# Test authentication
curl -H "Authorization: Bearer YOUR_JWT_TOKEN" \
     http://localhost:3005/api/v1/debug/auth_test

# Test protected route
curl -H "Authorization: Bearer YOUR_JWT_TOKEN" \
     http://localhost:3005/api/v1/debug/protected_test
```

## 📝 Lưu ý

- Đảm bảo JWT token được gửi đúng format: `Bearer <token>`
- Kiểm tra token chưa hết hạn (default 24 hours)
- User phải tồn tại trong database và có orders để test
