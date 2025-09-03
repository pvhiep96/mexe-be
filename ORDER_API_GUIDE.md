# Order API Guide - Shipping Information

## Order Creation API with Shipping Information

### Endpoint
```
POST /api/v1/orders
```

### Request Structure

```json
{
  "orders": {
    "payment_method": "cod",
    "delivery_type": "home",
    "guest_name": "Nguyen Van A",
    "guest_email": "customer@example.com", 
    "guest_phone": "0901234567",
    "notes": "Giao hàng buổi chiều",
    "shipping_info": {
      "shipping_name": "Nguyen Van A",
      "shipping_phone": "0987654321",
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
      },
      {
        "product_id": 2,
        "quantity": 1
      }
    ]
  }
}
```

### Field Descriptions

#### Order Fields
- `payment_method`: Payment method (cod, card, bank_transfer)
- `delivery_type`: Delivery type (home, store_pickup)
- `guest_name`: Customer name (for guest orders)
- `guest_email`: Customer email (for guest orders)
- `guest_phone`: Customer phone (for guest orders)
- `notes`: Additional notes for the order

#### Shipping Information Fields
- `shipping_name`: Recipient name
- `shipping_phone`: Recipient phone number
- `shipping_city`: Delivery city
- `shipping_district`: Delivery district
- `shipping_ward`: Delivery ward
- `shipping_postal_code`: Postal code
- `delivery_address`: Street address

#### Order Items
- `product_id`: Product ID
- `quantity`: Quantity to order

### Response Structure

```json
{
  "id": 123,
  "order_number": "ORD-20250831-ABCD1234",
  "status": "pending",
  "subtotal": 500000.0,
  "discount_amount": 0.0,
  "shipping_fee": 30000.0,
  "tax_amount": 0.0,
  "total_amount": 530000.0,
  "payment_method": "cod",
  "payment_status": "pending",
  "delivery_type": "home",
  "delivery_address": "123 Le Loi Street, Ben Nghe Ward, District 1, Ho Chi Minh City",
  "store_location": null,
  "notes": "Giao hàng buổi chiều",
  "guest_email": "customer@example.com",
  "guest_phone": "0901234567",
  "guest_name": "Nguyen Van A",
  "shipping_name": "Nguyen Van A",
  "shipping_phone": "0987654321",
  "shipping_city": "Ho Chi Minh City",
  "shipping_district": "District 1",
  "shipping_ward": "Ben Nghe Ward",
  "shipping_postal_code": "700000",
  "created_at": "2025-08-31T02:15:00.000Z",
  "order_items": [
    {
      "id": 456,
      "product_id": 1,
      "product_name": "Product Name",
      "quantity": 2,
      "unit_price": 250000.0,
      "total_price": 500000.0
    }
  ]
}
```

## Test Endpoint

For testing purposes, you can use:

```
POST /api/v1/test_orders/create_test_order
```

This endpoint creates a test order with sample shipping information.

## Admin View

After creating an order, admin users can view detailed shipping information at:

```
/admin/orders/{order_id}
```

The admin view displays:
- Customer information (name, phone, email)
- Shipping recipient information
- Full delivery address breakdown
- Delivery method (home delivery or store pickup)
- Order notes

## Database Fields Added

The following fields were added to the `orders` table:
- `shipping_name` (string): Recipient name
- `shipping_phone` (string): Recipient phone
- `shipping_city` (string): Delivery city
- `shipping_district` (string): Delivery district
- `shipping_ward` (string): Delivery ward
- `shipping_postal_code` (string): Postal code

## User ID Handling

- **Authenticated Users**: `user_id` is automatically set from `current_user`
- **Guest Orders**: Guest information is stored in `guest_name`, `guest_email`, `guest_phone`
- Orders support both authenticated and guest customers