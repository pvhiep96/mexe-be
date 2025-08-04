  # This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Seeding database..."

# Create settings
puts "Creating settings..."
Setting.create!([
  { setting_key: 'site_name', setting_value: 'Mexe - Phụ Kiện Ô Tô & Workspace', setting_type: 'string', description: 'Tên website' },
  { setting_key: 'site_description', setting_value: 'Chuyên cung cấp phụ kiện ô tô chất lượng cao và workspace hiệu quả', setting_type: 'string', description: 'Mô tả website' },
  { setting_key: 'contact_email', setting_value: 'info@mexe.com', setting_type: 'string', description: 'Email liên hệ' },
  { setting_key: 'contact_phone', setting_value: '1900-1234', setting_type: 'string', description: 'Số điện thoại liên hệ' },
  { setting_key: 'free_shipping_threshold', setting_value: '500000', setting_type: 'number', description: 'Ngưỡng miễn phí vận chuyển (VNĐ)' },
  { setting_key: 'default_shipping_fee', setting_value: '30000', setting_type: 'number', description: 'Phí vận chuyển mặc định (VNĐ)' }
])

# Create categories
puts "Creating categories..."
categories = Category.create!([
  { name: 'Phụ Kiện Ô Tô', slug: 'phu-kien-o-to', description: 'Các phụ kiện cần thiết cho ô tô', sort_order: 1 },
  { name: 'Camera Hành Trình', slug: 'camera-hanh-trinh', description: 'Camera ghi hình hành trình', parent_id: 1, sort_order: 1 },
  { name: 'Thảm Sàn', slug: 'tham-san', description: 'Thảm sàn ô tô', parent_id: 1, sort_order: 2 },
  { name: 'Nội Thất', slug: 'noi-that', description: 'Phụ kiện nội thất ô tô', parent_id: 1, sort_order: 3 },
  { name: 'Workspace', slug: 'workspace', description: 'Thiết bị workspace', sort_order: 2 },
  { name: 'Bàn Phím', slug: 'ban-phim', description: 'Bàn phím cơ và gaming', parent_id: 5, sort_order: 1 },
  { name: 'Chuột', slug: 'chuot', description: 'Chuột gaming và công thái học', parent_id: 5, sort_order: 2 },
  { name: 'Ghế Công Thái Học', slug: 'ghe-cong-thai-hoc', description: 'Ghế ngồi công thái học', parent_id: 5, sort_order: 3 }
])

# Create brands
puts "Creating brands..."
brands = Brand.create!([
  { name: 'Honda Genuine Parts', slug: 'honda-genuine-parts', description: 'Phụ kiện chính hãng Honda', founded_year: 1948, field: 'Automotive Parts', story: 'Honda Genuine Parts cung cấp phụ kiện chính hãng chất lượng cao', sort_order: 1 },
  { name: 'Toyota Genuine Parts', slug: 'toyota-genuine-parts', description: 'Phụ kiện chính hãng Toyota', founded_year: 1937, field: 'Automotive Parts', story: 'Toyota Genuine Parts đảm bảo chất lượng và độ bền', sort_order: 2 },
  { name: 'Hyundai Mobis', slug: 'hyundai-mobis', description: 'Phụ kiện Hyundai Mobis', founded_year: 1977, field: 'Automotive Parts', story: 'Hyundai Mobis với công nghệ tiên tiến', sort_order: 3 },
  { name: 'AUTOLIGHT', slug: 'autolight', description: 'Thiết bị chiếu sáng ô tô', founded_year: 2009, field: 'Automotive Lighting', story: 'Chuyên về thiết bị chiếu sáng xe ô tô', sort_order: 4 },
  { name: 'Hexcal', slug: 'hexcal', description: 'Thiết bị workspace', founded_year: 2020, field: 'Workspace Equipment', story: 'Thiết bị workspace hiện đại', sort_order: 5 },
  { name: 'Nuphy', slug: 'nuphy', description: 'Bàn phím cơ cao cấp', founded_year: 2019, field: 'Mechanical Keyboards', story: 'Bàn phím cơ chất lượng cao', sort_order: 6 }
])

# Create products
puts "Creating products..."
products = Product.create!([
  {
    name: 'Camera Hành Trình 4K AUTOLIGHT AL-2024',
    slug: 'camera-hanh-trinh-4k-autolight-al-2024',
    sku: 'CAM-AL-2024',
    description: 'Camera hành trình chất lượng 4K với góc nhìn rộng 170°',
    short_description: 'Camera hành trình 4K chất lượng cao',
    brand_id: 4,
    category_id: 2,
    price: 2500000,
    original_price: 3000000,
    discount_percent: 16.67,
    stock_quantity: 50,
    is_featured: true,
    is_new: true,
    warranty_period: 24
  },
  {
    name: 'Thảm Sàn Ô Tô Cao Cấp Honda Civic',
    slug: 'tham-san-o-to-cao-cap-honda-civic',
    sku: 'THAM-HC-001',
    description: 'Thảm sàn cao cấp dành riêng cho Honda Civic',
    short_description: 'Thảm sàn chính hãng Honda Civic',
    brand_id: 1,
    category_id: 3,
    price: 850000,
    original_price: 1000000,
    discount_percent: 15,
    stock_quantity: 100,
    is_hot: true,
    warranty_period: 12
  },
  {
    name: 'Bàn Phím Cơ Nuphy Air75',
    slug: 'ban-phim-co-nuphy-air75',
    sku: 'KB-NU-75',
    description: 'Bàn phím cơ không dây 75% với switch Gateron',
    short_description: 'Bàn phím cơ không dây cao cấp',
    brand_id: 6,
    category_id: 6,
    price: 3200000,
    original_price: 3500000,
    discount_percent: 8.57,
    stock_quantity: 25,
    is_featured: true,
    is_preorder: true,
    preorder_quantity: 10,
    preorder_end_date: Date.current + 30.days,
    warranty_period: 12
  },
  {
    name: 'Ghế Công Thái Học Hexcal Studio',
    slug: 'ghe-cong-thai-hoc-hexcal-studio',
    sku: 'GHE-HX-001',
    description: 'Ghế công thái học cao cấp với nhiều tùy chỉnh',
    short_description: 'Ghế công thái học chất lượng cao',
    brand_id: 5,
    category_id: 8,
    price: 8500000,
    original_price: 9500000,
    discount_percent: 10.53,
    stock_quantity: 15,
    is_new: true,
    warranty_period: 36
  }
])

# Create product specifications
puts "Creating product specifications..."
ProductSpecification.create!([
  { product_id: 1, spec_name: 'Độ phân giải', spec_value: '4K (3840x2160)', sort_order: 1 },
  { product_id: 1, spec_name: 'Góc nhìn', spec_value: '170°', sort_order: 2 },
  { product_id: 1, spec_name: 'Bộ nhớ', spec_value: '128GB', sort_order: 3 },
  { product_id: 1, spec_name: 'Pin', spec_value: 'Li-ion 1000mAh', sort_order: 4 },
  { product_id: 2, spec_name: 'Chất liệu', spec_value: 'Cao su + Nylon', sort_order: 1 },
  { product_id: 2, spec_name: 'Kích thước', spec_value: 'Phù hợp Honda Civic', sort_order: 2 },
  { product_id: 2, spec_name: 'Màu sắc', spec_value: 'Đen', sort_order: 3 },
  { product_id: 3, spec_name: 'Layout', spec_value: '75%', sort_order: 1 },
  { product_id: 3, spec_name: 'Switch', spec_value: 'Gateron Red', sort_order: 2 },
  { product_id: 3, spec_name: 'Kết nối', spec_value: 'Bluetooth 5.0 + USB-C', sort_order: 3 },
  { product_id: 3, spec_name: 'Pin', spec_value: '4000mAh', sort_order: 4 },
  { product_id: 4, spec_name: 'Tải trọng', spec_value: '150kg', sort_order: 1 },
  { product_id: 4, spec_name: 'Chất liệu', spec_value: 'Mesh + Nhôm', sort_order: 2 },
  { product_id: 4, spec_name: 'Điều chỉnh', spec_value: 'Cao, nghiêng, tựa lưng', sort_order: 3 }
])

# Create product images
puts "Creating product images..."
ProductImage.create!([
  { product_id: 1, image_url: '/images/products/camera-hanh-trinh-1.jpg', alt_text: 'Camera hành trình 4K AUTOLIGHT', is_primary: true, sort_order: 1 },
  { product_id: 1, image_url: '/images/products/camera-hanh-trinh-2.jpg', alt_text: 'Camera hành trình góc nhìn rộng', sort_order: 2 },
  { product_id: 2, image_url: '/images/products/tham-san-honda-1.jpg', alt_text: 'Thảm sàn Honda Civic', is_primary: true, sort_order: 1 },
  { product_id: 2, image_url: '/images/products/tham-san-honda-2.jpg', alt_text: 'Thảm sàn chất liệu cao cấp', sort_order: 2 },
  { product_id: 3, image_url: '/images/products/ban-phim-nuphy-1.jpg', alt_text: 'Bàn phím cơ Nuphy Air75', is_primary: true, sort_order: 1 },
  { product_id: 3, image_url: '/images/products/ban-phim-nuphy-2.jpg', alt_text: 'Bàn phím không dây', sort_order: 2 },
  { product_id: 4, image_url: '/images/products/ghe-hexcal-1.jpg', alt_text: 'Ghế công thái học Hexcal', is_primary: true, sort_order: 1 },
  { product_id: 4, image_url: '/images/products/ghe-hexcal-2.jpg', alt_text: 'Ghế điều chỉnh nhiều tư thế', sort_order: 2 }
])

# Create product variants
puts "Creating product variants..."
ProductVariant.create!([
  { product_id: 1, variant_name: 'Màu sắc', variant_value: 'Đen', price_adjustment: 0, stock_quantity: 30 },
  { product_id: 1, variant_name: 'Màu sắc', variant_value: 'Trắng', price_adjustment: 100000, stock_quantity: 20 },
  { product_id: 2, variant_name: 'Kích thước', variant_value: 'Sedan', price_adjustment: 0, stock_quantity: 60 },
  { product_id: 2, variant_name: 'Kích thước', variant_value: 'Hatchback', price_adjustment: 50000, stock_quantity: 40 },
  { product_id: 3, variant_name: 'Switch', variant_value: 'Gateron Red', price_adjustment: 0, stock_quantity: 15 },
  { product_id: 3, variant_name: 'Switch', variant_value: 'Gateron Brown', price_adjustment: 200000, stock_quantity: 10 },
  { product_id: 4, variant_name: 'Màu sắc', variant_value: 'Đen', price_adjustment: 0, stock_quantity: 10 },
  { product_id: 4, variant_name: 'Màu sắc', variant_value: 'Xám', price_adjustment: 300000, stock_quantity: 5 }
])

# Create shipping zones
puts "Creating shipping zones..."
ShippingZone.create!([
  { name: 'Hà Nội', cities: ['Hà Nội'], shipping_fee: 20000, free_shipping_threshold: 500000, estimated_days: '1-2 ngày' },
  { name: 'TP. Hồ Chí Minh', cities: ['TP. Hồ Chí Minh'], shipping_fee: 20000, free_shipping_threshold: 500000, estimated_days: '1-2 ngày' },
  { name: 'Đà Nẵng', cities: ['Đà Nẵng'], shipping_fee: 30000, free_shipping_threshold: 800000, estimated_days: '2-3 ngày' },
  { name: 'Các tỉnh khác', cities: ['Hải Phòng', 'Cần Thơ', 'Nghệ An', 'Thanh Hóa'], shipping_fee: 50000, free_shipping_threshold: 1000000, estimated_days: '3-5 ngày' }
])

# Create stores
puts "Creating stores..."
Store.create!([
  {
    name: 'Mexe Store Hà Nội',
    address: '123 Nguyễn Huệ, Hoàn Kiếm, Hà Nội',
    phone: '024-1234-5678',
    email: 'hanoi@mexe.com',
    city: 'Hà Nội',
    opening_hours: { 'Thứ 2-6': '8:00-22:00', 'Thứ 7': '8:00-21:00', 'Chủ nhật': '9:00-20:00' }
  },
  {
    name: 'Mexe Store TP.HCM',
    address: '456 Lê Lợi, Quận 1, TP.HCM',
    phone: '028-9876-5432',
    email: 'hcm@mexe.com',
    city: 'TP. Hồ Chí Minh',
    opening_hours: { 'Thứ 2-6': '8:00-22:00', 'Thứ 7': '8:00-21:00', 'Chủ nhật': '9:00-20:00' }
  },
  {
    name: 'Mexe Store Đà Nẵng',
    address: '789 Trần Phú, Hải Châu, Đà Nẵng',
    phone: '0236-5555-6666',
    email: 'danang@mexe.com',
    city: 'Đà Nẵng',
    opening_hours: { 'Thứ 2-6': '8:00-21:00', 'Thứ 7': '8:00-20:00', 'Chủ nhật': '9:00-19:00' }
  }
])

# Create coupons
puts "Creating coupons..."
Coupon.create!([
  {
    code: 'WELCOME10',
    name: 'Giảm giá chào mừng 10%',
    description: 'Giảm 10% cho đơn hàng đầu tiên',
    discount_type: 'percentage',
    discount_value: 10,
    min_order_amount: 500000,
    max_discount_amount: 200000,
    usage_limit: 1000,
    user_limit: 1,
    valid_from: Time.current,
    valid_until: Time.current + 6.months
  },
  {
    code: 'FREESHIP',
    name: 'Miễn phí vận chuyển',
    description: 'Miễn phí vận chuyển cho đơn hàng từ 500k',
    discount_type: 'fixed_amount',
    discount_value: 50000,
    min_order_amount: 500000,
    usage_limit: 500,
    user_limit: 1,
    valid_from: Time.current,
    valid_until: Time.current + 3.months
  }
])

# Create articles
puts "Creating articles..."
articles = Article.create!([
  {
    title: 'Top 10 phụ kiện ô tô cần thiết cho xe mới',
    slug: 'top-10-phu-kien-o-to-can-thiet',
    excerpt: 'Khám phá những phụ kiện ô tô quan trọng nhất mà mọi chủ xe mới nên trang bị để bảo vệ và nâng cao trải nghiệm lái xe.',
    content: 'Khi mua xe mới, việc trang bị những phụ kiện phù hợp không chỉ giúp bảo vệ xe mà còn nâng cao trải nghiệm lái xe và đảm bảo an toàn cho gia đình...',
    featured_image: '/images/articles/top-10-phu-kien.jpg',
    author: 'Mexe Team',
    category: 'Phụ Kiện Ô Tô',
    tags: ['phụ kiện', 'ô tô', 'bảo vệ', 'an toàn'],
    status: 'published',
    published_at: Time.current - 5.days,
    view_count: 1250
  },
  {
    title: 'Hướng dẫn chọn camera hành trình phù hợp',
    slug: 'huong-dan-chon-camera-hanh-trinh',
    excerpt: 'Tìm hiểu cách chọn camera hành trình tốt nhất cho xe của bạn với các tiêu chí quan trọng và gợi ý sản phẩm chất lượng.',
    content: 'Camera hành trình là một trong những phụ kiện quan trọng nhất cho xe ô tô hiện nay...',
    featured_image: '/images/articles/camera-hanh-trinh.jpg',
    author: 'Mexe Team',
    category: 'Công Nghệ',
    tags: ['camera', 'hành trình', '4K', 'an toàn'],
    status: 'published',
    published_at: Time.current - 3.days,
    view_count: 890
  },
  {
    title: '5 loại thảm sàn ô tô tốt nhất 2024',
    slug: '5-loai-tham-san-o-to-tot-nhat-2024',
    excerpt: 'So sánh các loại thảm sàn ô tô phổ biến và gợi ý những sản phẩm chất lượng cao giúp bảo vệ sàn xe hiệu quả.',
    content: 'Thảm sàn ô tô không chỉ giúp bảo vệ sàn xe khỏi bụi bẩn và nước mà còn tăng tính thẩm mỹ...',
    featured_image: '/images/articles/tham-san-o-to.jpg',
    author: 'Mexe Team',
    category: 'Phụ Kiện Ô Tô',
    tags: ['thảm sàn', 'bảo vệ', 'thẩm mỹ'],
    status: 'published',
    published_at: Time.current - 1.day,
    view_count: 567
  }
])

# Create article images
puts "Creating article images..."
ArticleImage.create!([
  { article_id: 1, image_url: '/images/articles/top-10-phu-kien-1.jpg', alt_text: 'Camera hành trình', caption: 'Camera hành trình bảo vệ quyền lợi', sort_order: 1 },
  { article_id: 1, image_url: '/images/articles/top-10-phu-kien-2.jpg', alt_text: 'Thảm sàn ô tô', caption: 'Thảm sàn bảo vệ sàn xe', sort_order: 2 },
  { article_id: 2, image_url: '/images/articles/camera-hanh-trinh-1.jpg', alt_text: 'Camera 4K', caption: 'Chất lượng hình ảnh 4K', sort_order: 1 },
  { article_id: 2, image_url: '/images/articles/camera-hanh-trinh-2.jpg', alt_text: 'Góc nhìn rộng', caption: 'Góc nhìn 170°', sort_order: 2 },
  { article_id: 3, image_url: '/images/articles/tham-san-1.jpg', alt_text: 'Thảm cao su', caption: 'Thảm cao su chống trượt', sort_order: 1 },
  { article_id: 3, image_url: '/images/articles/tham-san-2.jpg', alt_text: 'Thảm nylon', caption: 'Thảm nylon dễ vệ sinh', sort_order: 2 }
])

puts "Database seeding completed successfully!"
puts "Created:"
puts "- #{Setting.count} settings"
puts "- #{Category.count} categories"
puts "- #{Brand.count} brands"
puts "- #{Product.count} products"
puts "- #{ProductSpecification.count} product specifications"
puts "- #{ProductImage.count} product images"
puts "- #{ProductVariant.count} product variants"
puts "- #{ShippingZone.count} shipping zones"
puts "- #{Store.count} stores"
puts "- #{Coupon.count} coupons"
puts "- #{Article.count} articles"
puts "- #{ArticleImage.count} article images"
