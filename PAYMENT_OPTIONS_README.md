# Payment Options for Orders

## Tổng quan
Đã thêm các trường thanh toán mới vào Order model để hỗ trợ các phương thức thanh toán linh hoạt.

## Các trường mới

### 1. Full Payment Transfer (Thanh toán toàn bộ)
- **`full_payment_transfer`** (boolean): Có cho phép thanh toán toàn bộ qua chuyển khoản không
- **`full_payment_discount_percentage`** (decimal): Phần trăm giảm giá khi thanh toán toàn bộ

### 2. Partial Advance Payment (Thanh toán trước một phần)
- **`partial_advance_payment`** (boolean): Có cho phép thanh toán trước một phần không
- **`advance_payment_percentage`** (decimal): Phần trăm thanh toán trước
- **`advance_payment_discount_percentage`** (decimal): Phần trăm giảm giá khi thanh toán trước

## Cách sử dụng

### 1. Chạy Migration
```bash
cd mexe-be
rails db:migrate
```

### 2. Test Payment Options
```bash
rails runner test_payment_options.rb
```

### 3. Tạo Order với Payment Options

#### API Request Example:
```json
{
  "orders": {
    "order_number": "ORD-20250115-ABC123",
    "payment_method": "cod",
    "delivery_type": "home",
    "guest_name": "Nguyen Van A",
    "guest_email": "test@example.com",
    "guest_phone": "0901234567",
    "notes": "Giao hàng buổi chiều",
    "full_payment_transfer": true,
    "full_payment_discount_percentage": 5.0,
    "partial_advance_payment": false,
    "advance_payment_percentage": 0.0,
    "advance_payment_discount_percentage": 0.0,
    "shipping_info": {
      "shipping_name": "Nguyen Van A",
      "shipping_phone": "0901234567",
      "shipping_city": "Ho Chi Minh City",
      "shipping_district": "District 1",
      "shipping_ward": "Ben Nghe Ward",
      "shipping_postal_code": "700000",
      "delivery_address": "123 Le Loi Street"
    },
    "order_items": [
      {
        "product_id": 1,
        "quantity": 2
      }
    ]
  }
}
```

## Methods trong Order Model

### 1. `full_payment_amount`
Tính số tiền thanh toán toàn bộ (có giảm giá nếu có)
```ruby
order.full_payment_amount
# => 950000 (nếu total_amount = 1000000 và discount = 5%)
```

### 2. `advance_payment_amount`
Tính số tiền thanh toán trước
```ruby
order.advance_payment_amount
# => 300000 (nếu total_amount = 1000000 và advance_payment_percentage = 30%)
```

### 3. `advance_payment_with_discount`
Tính số tiền thanh toán trước (có giảm giá nếu có)
```ruby
order.advance_payment_with_discount
# => 285000 (nếu advance_payment_amount = 300000 và discount = 5%)
```

### 4. `remaining_payment_amount`
Tính số tiền còn lại phải thanh toán
```ruby
order.remaining_payment_amount
# => 715000 (nếu total_amount = 1000000 và đã thanh toán trước 285000)
```

### 5. `payment_summary`
Lấy tóm tắt tất cả thông tin thanh toán
```ruby
order.payment_summary
# => {
#   total_amount: 1000000,
#   full_payment_transfer: true,
#   full_payment_amount: 950000,
#   full_payment_discount: 50000,
#   partial_advance_payment: false,
#   advance_payment_amount: 0,
#   advance_payment_with_discount: 0,
#   advance_payment_discount: 0,
#   remaining_amount: 1000000
# }
```

## API Response

Order serializer sẽ trả về các trường mới:
```json
{
  "id": 1,
  "order_number": "ORD-20250115-ABC123",
  "total_amount": 1000000,
  "full_payment_transfer": true,
  "full_payment_discount_percentage": 5.0,
  "partial_advance_payment": false,
  "advance_payment_percentage": 0.0,
  "advance_payment_discount_percentage": 0.0,
  "payment_summary": {
    "total_amount": 1000000,
    "full_payment_transfer": true,
    "full_payment_amount": 950000,
    "full_payment_discount": 50000,
    "partial_advance_payment": false,
    "advance_payment_amount": 0,
    "advance_payment_with_discount": 0,
    "advance_payment_discount": 0,
    "remaining_amount": 1000000
  }
}
```

## Frontend Integration

### 1. Cập nhật Order Interface
```typescript
interface Order {
  // ... existing fields
  full_payment_transfer: boolean;
  full_payment_discount_percentage: number;
  partial_advance_payment: boolean;
  advance_payment_percentage: number;
  advance_payment_discount_percentage: number;
  payment_summary: {
    total_amount: number;
    full_payment_transfer: boolean;
    full_payment_amount: number;
    full_payment_discount: number;
    partial_advance_payment: boolean;
    advance_payment_amount: number;
    advance_payment_with_discount: number;
    advance_payment_discount: number;
    remaining_amount: number;
  };
}
```

### 2. Sử dụng trong Checkout Component
```typescript
const handlePaymentOptions = (order: Order) => {
  if (order.full_payment_transfer) {
    const discountAmount = order.total_amount * (order.full_payment_discount_percentage / 100);
    const finalAmount = order.total_amount - discountAmount;
    console.log(`Thanh toán toàn bộ: ${finalAmount}₫ (giảm ${discountAmount}₫)`);
  }
  
  if (order.partial_advance_payment) {
    const advanceAmount = order.total_amount * (order.advance_payment_percentage / 100);
    const advanceDiscount = advanceAmount * (order.advance_payment_discount_percentage / 100);
    const finalAdvanceAmount = advanceAmount - advanceDiscount;
    const remainingAmount = order.total_amount - finalAdvanceAmount;
    console.log(`Thanh toán trước: ${finalAdvanceAmount}₫, Còn lại: ${remainingAmount}₫`);
  }
};
```

## Database Schema

```sql
ALTER TABLE orders ADD COLUMN full_payment_transfer BOOLEAN DEFAULT FALSE;
ALTER TABLE orders ADD COLUMN full_payment_discount_percentage DECIMAL(5,2) DEFAULT 0.0;
ALTER TABLE orders ADD COLUMN partial_advance_payment BOOLEAN DEFAULT FALSE;
ALTER TABLE orders ADD COLUMN advance_payment_percentage DECIMAL(5,2) DEFAULT 0.0;
ALTER TABLE orders ADD COLUMN advance_payment_discount_percentage DECIMAL(5,2) DEFAULT 0.0;

-- Indexes for better performance
CREATE INDEX idx_orders_full_payment_transfer ON orders(full_payment_transfer);
CREATE INDEX idx_orders_partial_advance_payment ON orders(partial_advance_payment);
```

## Lưu ý

1. **Validation**: Các trường percentage phải từ 0-100
2. **Default Values**: Tất cả trường đều có giá trị mặc định
3. **Backward Compatibility**: Không ảnh hưởng đến orders cũ
4. **Performance**: Đã thêm indexes cho các trường boolean

## Troubleshooting

### Lỗi thường gặp:
1. **Migration failed**: Chạy `rails db:migrate:status` để kiểm tra
2. **Validation errors**: Kiểm tra giá trị percentage (0-100)
3. **Serializer errors**: Đảm bảo OrderSerializer đã được cập nhật

### Debug:
```ruby
# Kiểm tra order có payment options không
order = Order.last
order.full_payment_transfer?
order.partial_advance_payment?
order.payment_summary
```
