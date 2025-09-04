# Early Order API Guide

## Tổng quan
API này cung cấp dữ liệu cho 4 tab trong phần "CÙNG MEXE ĐẶT HÀNG VỀ TAY SỚM NHẤT" trên frontend.

## Endpoint
```
GET /api/v1/home/early_order
```

## Response Format
```json
{
  "success": true,
  "data": {
    "trending": [...],        // Dự án thịnh hành
    "new_launched": [...],    // Mới ra mắt  
    "ending_soon": [...],     // Sắp kết thúc
    "arriving_soon": [...]    // Sắp về hàng
  }
}
```

## Các Tab và Logic

### 1. Trending (Dự án thịnh hành)
- **Cột DB**: `is_trending = true`
- **Logic**: Sản phẩm có `is_hot = true` HOẶC `is_featured = true`
- **Sắp xếp**: `created_at DESC`
- **Giới hạn**: 15 sản phẩm

### 2. New Launched (Mới ra mắt)
- **Cột DB**: `is_new = true`
- **Logic**: Sản phẩm mới được ra mắt
- **Sắp xếp**: `created_at DESC`
- **Giới hạn**: 15 sản phẩm

### 3. Ending Soon (Sắp kết thúc)
- **Cột DB**: `is_ending_soon = true`
- **Logic**: Sản phẩm sắp kết thúc chiến dịch
- **Sắp xếp**: `created_at DESC`
- **Giới hạn**: 15 sản phẩm

### 4. Arriving Soon (Sắp về hàng)
- **Cột DB**: `is_arriving_soon = true`
- **Logic**: Sản phẩm sắp về hàng
- **Sắp xếp**: `created_at DESC`
- **Giới hạn**: 15 sản phẩm

## Điều kiện chung
- `is_active = true`
- `stock_quantity > 0`
- Bao gồm thông tin: brand, category, images, variants, specifications

## Cách sử dụng trên Frontend

### 1. Gọi API
```javascript
const response = await fetch('/api/v1/home/early_order');
const data = await response.json();

if (data.success) {
  const { trending, new_launched, ending_soon, arriving_soon } = data.data;
  
  // Hiển thị sản phẩm theo tab
  switch(activeTab) {
    case 'trending':
      setProducts(trending);
      break;
    case 'new':
      setProducts(new_launched);
      break;
    case 'ending':
      setProducts(ending_soon);
      break;
    case 'arriving':
      setProducts(arriving_soon);
      break;
  }
}
```

### 2. Cập nhật EarlyOrder Component
Thay vì filter local data, gọi API mới khi chuyển tab:

```javascript
const handleTabChange = async (tab) => {
  setActiveTab(tab);
  
  // Gọi API để lấy dữ liệu mới
  const response = await apiClient.getEarlyOrderData();
  if (response.success) {
    const tabData = response.data[getTabKey(tab)];
    setProducts(tabData);
  }
};
```

## Database Schema

### Cột mới được thêm vào bảng `products`:
```sql
ALTER TABLE products ADD COLUMN is_trending BOOLEAN DEFAULT FALSE;
ALTER TABLE products ADD COLUMN is_ending_soon BOOLEAN DEFAULT FALSE;
ALTER TABLE products ADD COLUMN is_arriving_soon BOOLEAN DEFAULT FALSE;
```

## Migration
Migration đã được tạo và chạy:
- File: `db/migrate/20250904064831_add_tab_columns_to_products.rb`
- Status: ✅ Completed

## Seeds Data
Dữ liệu mẫu đã được tạo:
- **Trending**: 7 sản phẩm
- **New**: 4 sản phẩm  
- **Ending Soon**: 3 sản phẩm
- **Arriving Soon**: 4 sản phẩm

## Lợi ích
1. **Performance**: Không cần filter dữ liệu trên frontend
2. **Flexibility**: Dễ dàng thay đổi logic cho từng tab
3. **Scalability**: Có thể thêm pagination nếu cần
4. **Maintainability**: Logic tập trung ở backend, code DRY
5. **Real-time**: Dữ liệu luôn được cập nhật từ database
6. **Code Quality**: Sử dụng hàm chung `get_products_by_flag()` thay vì 4 hàm riêng biệt

## Testing
API đã được test và hoạt động tốt:
```bash
curl http://localhost:3005/api/v1/home/early_order
```

Response trả về đầy đủ thông tin sản phẩm cho cả 4 tab.
