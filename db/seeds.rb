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
[
  { setting_key: 'site_name', setting_value: 'Mexe - Phụ Kiện Ô Tô & Workspace', setting_type: 'string', description: 'Tên website' },
  { setting_key: 'site_description', setting_value: 'Chuyên cung cấp phụ kiện ô tô chất lượng cao và workspace hiệu quả', setting_type: 'string', description: 'Mô tả website' },
  { setting_key: 'contact_email', setting_value: 'info@mexe.com', setting_type: 'string', description: 'Email liên hệ' },
  { setting_key: 'contact_phone', setting_value: '1900-1234', setting_type: 'string', description: 'Số điện thoại liên hệ' },
  { setting_key: 'free_shipping_threshold', setting_value: '500000', setting_type: 'number', description: 'Ngưỡng miễn phí vận chuyển (VNĐ)' },
  { setting_key: 'default_shipping_fee', setting_value: '30000', setting_type: 'number', description: 'Phí vận chuyển mặc định (VNĐ)' }
].each do |setting|
  Setting.find_or_create_by(setting_key: setting[:setting_key]) do |s|
    s.assign_attributes(setting)
  end
end

# Create categories
puts "Creating categories..."
# Create parent categories first
auto_category = Category.create(name: 'Phụ Kiện Ô Tô', slug: 'phu-kien-o-to', description: 'Các phụ kiện cần thiết cho ô tô')

puts "Auto category ID: #{auto_category.id}" if auto_category.persisted?

# Create subcategories  
if auto_category.persisted?
  Category.create([
    { name: 'Camera Hành Trình', slug: 'camera-hanh-trinh', description: 'Camera ghi hình hành trình', parent_id: auto_category.id },
    { name: 'Thảm Sàn', slug: 'tham-san', description: 'Thảm sàn ô tô', parent_id: auto_category.id },
    { name: 'Nội Thất', slug: 'noi-that', description: 'Phụ kiện nội thất ô tô', parent_id: auto_category.id },
    { name: 'Đèn LED', slug: 'den-led', description: 'Đèn LED trang trí và chiếu sáng', parent_id: auto_category.id },
    { name: 'Bảo Vệ', slug: 'bao-ve', description: 'Phụ kiện bảo vệ xe', parent_id: auto_category.id },
    { name: 'Âm Thanh', slug: 'am-thanh', description: 'Hệ thống âm thanh xe hơi', parent_id: auto_category.id }
  ])
end

# Create brands
puts "Creating brands..."
brands = Brand.create([
  { name: 'Honda Genuine Parts', slug: 'honda-genuine-parts', description: 'Phụ kiện chính hãng Honda', founded_year: 1948, field: 'Automotive Parts', story: 'Honda Genuine Parts cung cấp phụ kiện chính hãng chất lượng cao', sort_order: 1 },
  { name: 'Toyota Genuine Parts', slug: 'toyota-genuine-parts', description: 'Phụ kiện chính hãng Toyota', founded_year: 1937, field: 'Automotive Parts', story: 'Toyota Genuine Parts đảm bảo chất lượng và độ bền', sort_order: 2 },
  { name: 'Hyundai Mobis', slug: 'hyundai-mobis', description: 'Phụ kiện Hyundai Mobis', founded_year: 1977, field: 'Automotive Parts', story: 'Hyundai Mobis với công nghệ tiên tiến', sort_order: 3 },
  { name: 'AUTOLIGHT', slug: 'autolight', description: 'Thiết bị chiếu sáng ô tô', founded_year: 2009, field: 'Automotive Lighting', story: 'Chuyên về thiết bị chiếu sáng xe ô tô', sort_order: 4 },
  { name: 'BlackVue', slug: 'blackvue', description: 'Camera hành trình cao cấp', founded_year: 2007, field: 'Dash Cameras', story: 'Thương hiệu camera hành trình hàng đầu thế giới', sort_order: 5 },
  { name: 'WeatherTech', slug: 'weathertech', description: 'Phụ kiện bảo vệ xe', founded_year: 1989, field: 'Automotive Protection', story: 'Chuyên về phụ kiện bảo vệ xe chất lượng cao', sort_order: 6 },
  { name: 'Pioneer', slug: 'pioneer', description: 'Hệ thống âm thanh xe hơi', founded_year: 1938, field: 'Car Audio', story: 'Thương hiệu âm thanh xe hơi hàng đầu', sort_order: 7 },
  { name: '3M', slug: '3m', description: 'Phụ kiện bảo vệ và làm sạch', founded_year: 1902, field: 'Automotive Care', story: 'Công nghệ bảo vệ và chăm sóc xe tiên tiến', sort_order: 8 }
])

# Create admin users first (needed for client_id assignment)
puts "Creating admin users..."

# Super Admin
super_admin = AdminUser.find_or_create_by(email: 'admin@mexe.com') do |admin|
  admin.password = 'password123'
  admin.password_confirmation = 'password123'
  admin.role = :super_admin
end

# Client users
client1 = AdminUser.find_or_create_by(email: 'client1@mexe.com') do |admin|
  admin.password = 'password123'
  admin.password_confirmation = 'password123'
  admin.role = :client
  admin.client_name = 'AUTOLIGHT Vietnam'
  admin.client_phone = '0901234567'
  admin.client_address = '123 Nguyễn Văn Cừ, Q.1, TP.HCM'
end

client2 = AdminUser.find_or_create_by(email: 'client2@mexe.com') do |admin|
  admin.password = 'password123'
  admin.password_confirmation = 'password123'
  admin.role = :client
  admin.client_name = 'Honda Parts Dealer'
  admin.client_phone = '0907654321'
  admin.client_address = '456 Lê Văn Việt, Q.9, TP.HCM'
end

# Create products with client_id assignment
puts "Creating products..."
products = Product.create([
  {
    name: 'Camera Hành Trình 4K AUTOLIGHT AL-2024',
    slug: 'camera-hanh-trinh-4k-autolight-al-2024',
    sku: 'CAM-AL-2024',
    description: 'Camera hành trình chất lượng 4K với góc nhìn rộng 170°',
    short_description: 'Camera hành trình 4K chất lượng cao',
    brand_id: 4,
    category_id: 2,
    client_id: client1.id, # AUTOLIGHT products to client1
    price: 2500000,
    original_price: 3000000,
    discount_percent: 16.67,
    stock_quantity: 50,
    is_essential_accessories: true,
    is_new: true,
    warranty_period: 24
  },
  {
    name: 'Camera Hành Trình BlackVue DR750X-2CH',
    slug: 'camera-hanh-trinh-blackvue-dr750x-2ch',
    sku: 'CAM-BV-750X',
    description: 'Camera hành trình 2 kênh Full HD với GPS và WiFi',
    short_description: 'Camera hành trình 2 kênh cao cấp BlackVue',
    brand_id: 5,
    category_id: 2,
    client_id: client1.id, # BlackVue products to client1
    price: 4500000,
    original_price: 5000000,
    discount_percent: 10,
    stock_quantity: 30,
    is_essential_accessories: true,
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
    client_id: client2.id, # Honda products to client2
    price: 850000,
    original_price: 1000000,
    discount_percent: 15,
    stock_quantity: 100,
    is_hot: true,
    warranty_period: 12
  },
  {
    name: 'Thảm Sàn WeatherTech Custom Fit',
    slug: 'tham-san-weathertech-custom-fit',
    sku: 'THAM-WT-001',
    description: 'Thảm sàn cao cấp WeatherTech với thiết kế tùy chỉnh',
    short_description: 'Thảm sàn cao cấp WeatherTech',
    brand_id: 6,
    category_id: 3,
    client_id: client2.id, # WeatherTech products to client2
    price: 1200000,
    original_price: 1400000,
    discount_percent: 14.29,
    stock_quantity: 75,
    is_hot: true,
    warranty_period: 24
  },
  {
    name: 'Đèn LED Trang Trí Nội Thất Xe',
    slug: 'den-led-trang-tri-noi-that-xe',
    sku: 'DEN-LED-001',
    description: 'Đèn LED trang trí nội thất xe với 16 màu sắc',
    short_description: 'Đèn LED trang trí nội thất đa màu',
    brand_id: 4,
    category_id: 4,
    client_id: client1.id, # AUTOLIGHT products to client1
    price: 350000,
    original_price: 400000,
    discount_percent: 12.5,
    stock_quantity: 200,
    is_new: true,
    warranty_period: 12
  },
  {
    name: 'Bộ Đèn LED Gầm Xe AUTOLIGHT',
    slug: 'bo-den-led-gam-xe-autolight',
    sku: 'DEN-GAM-001',
    description: 'Bộ đèn LED gầm xe với điều khiển từ xa',
    short_description: 'Đèn LED gầm xe điều khiển từ xa',
    brand_id: 4,
    category_id: 4,
    client_id: client1.id, # AUTOLIGHT products to client1
    price: 800000,
    original_price: 900000,
    discount_percent: 11.11,
    stock_quantity: 80,
    is_essential_accessories: true,
    warranty_period: 12
  },
  {
    name: 'Bộ Bảo Vệ Gương Chiếu Hậu 3M',
    slug: 'bo-bao-ve-guong-chieu-hau-3m',
    sku: 'BAOVE-3M-001',
    description: 'Bộ bảo vệ gương chiếu hậu chống va đập 3M',
    short_description: 'Bảo vệ gương chiếu hậu chống va đập',
    brand_id: 8,
    category_id: 5,
    client_id: client1.id, # 3M products to client1
    price: 250000,
    original_price: 300000,
    discount_percent: 16.67,
    stock_quantity: 150,
    is_new: true,
    warranty_period: 12
  },
  {
    name: 'Bộ Bảo Vệ Cửa Xe WeatherTech',
    slug: 'bo-bao-ve-cua-xe-weathertech',
    sku: 'BAOVE-WT-002',
    description: 'Bộ bảo vệ cửa xe chống va đập và trầy xước',
    short_description: 'Bảo vệ cửa xe chống va đập',
    brand_id: 6,
    category_id: 5,
    client_id: client2.id, # WeatherTech products to client2
    price: 450000,
    original_price: 500000,
    discount_percent: 10,
    stock_quantity: 100,
    is_hot: true,
    warranty_period: 24
  },
  {
    name: 'Loa Xe Hơi Pioneer TS-A1670F',
    slug: 'loa-xe-hoi-pioneer-ts-a1670f',
    sku: 'LOA-PIO-001',
    description: 'Loa xe hơi 6.5 inch với âm thanh mạnh mẽ',
    short_description: 'Loa xe hơi Pioneer chất lượng cao',
    brand_id: 7,
    category_id: 6,
    client_id: client2.id, # Pioneer products to client2
    price: 1200000,
    original_price: 1400000,
    discount_percent: 14.29,
    stock_quantity: 60,
    is_essential_accessories: true,
    warranty_period: 12
  },
  {
    name: 'Amply Xe Hơi Pioneer GM-D8604',
    slug: 'amply-xe-hoi-pioneer-gm-d8604',
    sku: 'AMP-PIO-001',
    description: 'Amply xe hơi 4 kênh công suất cao',
    short_description: 'Amply xe hơi 4 kênh Pioneer',
    brand_id: 7,
    category_id: 6,
    client_id: client2.id, # Pioneer products to client2
    price: 2800000,
    original_price: 3200000,
    discount_percent: 12.5,
    stock_quantity: 40,
    is_new: true,
    warranty_period: 24
  }
])

# Create product specifications
puts "Creating product specifications..."
ProductSpecification.create([
  # Camera AUTOLIGHT AL-2024
  { product_id: 1, spec_name: 'Độ phân giải', spec_value: '4K (3840x2160)', sort_order: 1 },
  { product_id: 1, spec_name: 'Góc nhìn', spec_value: '170°', sort_order: 2 },
  { product_id: 1, spec_name: 'Bộ nhớ', spec_value: '128GB', sort_order: 3 },
  { product_id: 1, spec_name: 'Pin', spec_value: 'Li-ion 1000mAh', sort_order: 4 },
  
  # Camera BlackVue DR750X-2CH
  { product_id: 2, spec_name: 'Độ phân giải', spec_value: 'Full HD (1920x1080)', sort_order: 1 },
  { product_id: 2, spec_name: 'Số kênh', spec_value: '2 kênh (Trước + Sau)', sort_order: 2 },
  { product_id: 2, spec_name: 'GPS', spec_value: 'Có', sort_order: 3 },
  { product_id: 2, spec_name: 'WiFi', spec_value: '2.4GHz', sort_order: 4 },
  
  # Thảm sàn Honda Civic
  { product_id: 3, spec_name: 'Chất liệu', spec_value: 'Cao su + Nylon', sort_order: 1 },
  { product_id: 3, spec_name: 'Kích thước', spec_value: 'Phù hợp Honda Civic', sort_order: 2 },
  { product_id: 3, spec_name: 'Màu sắc', spec_value: 'Đen', sort_order: 3 },
  
  # Thảm sàn WeatherTech
  { product_id: 4, spec_name: 'Chất liệu', spec_value: 'Cao su tự nhiên', sort_order: 1 },
  { product_id: 4, spec_name: 'Thiết kế', spec_value: 'Custom Fit', sort_order: 2 },
  { product_id: 4, spec_name: 'Chống trượt', spec_value: 'Có', sort_order: 3 },
  
  # Đèn LED nội thất
  { product_id: 5, spec_name: 'Số màu', spec_value: '16 màu sắc', sort_order: 1 },
  { product_id: 5, spec_name: 'Điều khiển', spec_value: 'Remote + App', sort_order: 2 },
  { product_id: 5, spec_name: 'Công suất', spec_value: '12V', sort_order: 3 },
  
  # Đèn LED gầm xe
  { product_id: 6, spec_name: 'Công suất', spec_value: '12V', sort_order: 1 },
  { product_id: 6, spec_name: 'Điều khiển', spec_value: 'Remote từ xa', sort_order: 2 },
  { product_id: 6, spec_name: 'Độ sáng', spec_value: '6000K', sort_order: 3 },
  
  # Bảo vệ gương 3M
  { product_id: 7, spec_name: 'Chất liệu', spec_value: 'Polyurethane 3M', sort_order: 1 },
  { product_id: 7, spec_name: 'Độ dày', spec_value: '2mm', sort_order: 2 },
  { product_id: 7, spec_name: 'Màu sắc', spec_value: 'Trong suốt', sort_order: 3 },
  
  # Bảo vệ cửa WeatherTech
  { product_id: 8, spec_name: 'Chất liệu', spec_value: 'Polyurethane cao cấp', sort_order: 1 },
  { product_id: 8, spec_name: 'Độ dày', spec_value: '3mm', sort_order: 2 },
  { product_id: 8, spec_name: 'Màu sắc', spec_value: 'Đen', sort_order: 3 },
  
  # Loa Pioneer
  { product_id: 9, spec_name: 'Kích thước', spec_value: '6.5 inch', sort_order: 1 },
  { product_id: 9, spec_name: 'Công suất', spec_value: '50W RMS', sort_order: 2 },
  { product_id: 9, spec_name: 'Tần số', spec_value: '35Hz - 22kHz', sort_order: 3 },
  
  # Amply Pioneer
  { product_id: 10, spec_name: 'Số kênh', spec_value: '4 kênh', sort_order: 1 },
  { product_id: 10, spec_name: 'Công suất', spec_value: '100W x 4 @ 4Ω', sort_order: 2 },
  { product_id: 10, spec_name: 'Điện áp', spec_value: '12V', sort_order: 3 }
])

# Create product images (Note: Using sample URLs, in production these would be actual uploaded files)
puts "Creating product images..."
puts "Note: ProductImages will be created without actual files - you can upload real images through the admin interface"
# For now, we'll skip creating ProductImages in seeds since CarrierWave requires actual files
# You can upload images through the admin interface after running seeds

# Create product descriptions
puts "Creating product descriptions..."
ProductDescription.create([
  # Camera AUTOLIGHT AL-2024 descriptions
  {
    product_id: 1,
    title: 'Đặc điểm nổi bật',
    content: '<p><strong>Camera Hành Trình 4K AUTOLIGHT AL-2024</strong> là sản phẩm camera hành trình cao cấp với công nghệ ghi hình 4K Ultra HD, mang đến chất lượng hình ảnh cực kỳ sắc nét cả ngày và đêm.</p>

<ul>
<li>🎥 <strong>Chất lượng 4K Ultra HD:</strong> Ghi hình với độ phân giải 3840x2160, đảm bảo mọi chi tiết đều được ghi lại rõ ràng</li>
<li>📱 <strong>Góc nhìn siêu rộng 170°:</strong> Bao quát toàn bộ tầm nhìn phía trước, không bỏ sót bất kỳ chi tiết nào</li>
<li>🌙 <strong>Chế độ ghi đêm WDR:</strong> Công nghệ cảm biến ánh sáng tiên tiến, cho hình ảnh rõ nét ngay cả trong điều kiện ánh sáng yếu</li>
<li>💾 <strong>Lưu trữ 128GB:</strong> Bộ nhớ trong lớn, lưu trữ hàng giờ video chất lượng cao</li>
</ul>',
    sort_order: 1
  },
  {
    product_id: 1,
    title: 'Tính năng thông minh',
    content: '<p>Camera được trang bị nhiều tính năng thông minh giúp tăng cường an toàn và tiện ích:</p>

<ul>
<li>🚗 <strong>G-Sensor thông minh:</strong> Tự động khóa file khi phát hiện va chạm hoặc phanh gấp</li>
<li>🔄 <strong>Ghi đè tự động:</strong> Tự động ghi đè video cũ khi bộ nhớ đầy, đảm bảo luôn ghi được video mới</li>
<li>🔋 <strong>Pin dự phòng Li-ion 1000mAh:</strong> Tiếp tục ghi hình ngay cả khi tắt máy</li>
<li>📺 <strong>LCD 3 inch:</strong> Màn hình lớn, xem lại video trực tiếp trên camera</li>
</ul>',
    sort_order: 2
  },
  
  # Camera BlackVue DR750X-2CH descriptions
  {
    product_id: 2,
    title: 'Camera hành trình 2 kênh cao cấp',
    content: '<p><strong>BlackVue DR750X-2CH</strong> là camera hành trình 2 kênh cao cấp với công nghệ WiFi và GPS tích hợp, mang đến giải pháp giám sát toàn diện cho xe của bạn.</p>

<ul>
<li>📹 <strong>2 kênh ghi hình:</strong> Ghi hình đồng thời phía trước và sau xe</li>
<li>📡 <strong>GPS tích hợp:</strong> Ghi lại vị trí, tốc độ và tuyến đường</li>
<li>📶 <strong>WiFi 2.4GHz:</strong> Kết nối nhanh chóng với smartphone</li>
<li>💾 <strong>Bộ nhớ microSD:</strong> Hỗ trợ thẻ nhớ lên đến 256GB</li>
</ul>',
    sort_order: 1
  },
  
  # Thảm sàn Honda Civic descriptions
  {
    product_id: 3,
    title: 'Thiết kế hoàn hảo cho Honda Civic',
    content: '<p><strong>Thảm Sàn Ô Tô Cao Cấp Honda Civic</strong> được thiết kế riêng biệt cho từng dòng xe Honda Civic, đảm bảo sự vừa vặn hoàn hảo và bảo vệ tối ưu cho sàn xe.</p>

<h4>Đặc điểm vượt trội:</h4>
<ul>
<li>✅ <strong>Vừa vặn 100%:</strong> Được gia công chính xác theo khuôn sàn xe Honda Civic</li>
<li>💧 <strong>Chống thấm nước:</strong> Bảo vệ sàn xe khỏi nước, bùn đất và các chất lỏng khác</li>
<li>🧽 <strong>Dễ vệ sinh:</strong> Chỉ cần nước và xà phòng để vệ sinh sạch sẽ</li>
<li>👟 <strong>Chống trượt:</strong> Bề mặt có rãnh chống trượt, đảm bảo an toàn khi lái xe</li>
</ul>',
    sort_order: 1
  },
  {
    product_id: 3,
    title: 'Chất liệu cao cấp',
    content: '<p>Sản phẩm được làm từ chất liệu cao su tự nhiên kết hợp sợi Nylon có độ bền cao:</p>

<ul>
<li>🏭 <strong>Cao su tự nhiên:</strong> An toàn với sức khỏe, không mùi, không độc hại</li>
<li>🧵 <strong>Sợi Nylon gia cường:</strong> Tăng độ bền, chống xé rách và biến dạng</li>
<li>🎨 <strong>Màu đen sang trọng:</strong> Phù hợp với mọi nội thất xe, tăng tính thẩm mỹ</li>
<li>⚡ <strong>Độ bền cao:</strong> Sử dụng được trong nhiều năm mà không bị hỏng</li>
</ul>',
    sort_order: 2
  },

  # Thảm sàn WeatherTech descriptions
  {
    product_id: 4,
    title: 'Thảm sàn cao cấp WeatherTech',
    content: '<p><strong>Thảm Sàn WeatherTech Custom Fit</strong> được thiết kế đặc biệt với công nghệ DigitalFit™, tạo ra sự vừa vặn hoàn hảo cho từng dòng xe cụ thể.</p>

<ul>
<li>🎯 <strong>DigitalFit™ Technology:</strong> Thiết kế chính xác theo từng dòng xe</li>
<li>💧 <strong>Chống thấm nước hoàn hảo:</strong> Bảo vệ sàn xe khỏi mọi loại chất lỏng</li>
<li>🧽 <strong>Dễ vệ sinh:</strong> Chỉ cần nước để làm sạch</li>
<li>👟 <strong>Chống trượt tối ưu:</strong> Bề mặt có rãnh chống trượt hiệu quả</li>
</ul>',
    sort_order: 1
  },

  # Đèn LED nội thất descriptions
  {
    product_id: 5,
    title: 'Đèn LED trang trí nội thất đa màu',
    content: '<p><strong>Đèn LED Trang Trí Nội Thất Xe</strong> với 16 màu sắc rực rỡ, tạo không gian nội thất xe sang trọng và hiện đại.</p>

<ul>
<li>🎨 <strong>16 màu sắc:</strong> Tùy chỉnh theo sở thích cá nhân</li>
<li>📱 <strong>Điều khiển từ xa:</strong> Remote và ứng dụng smartphone</li>
<li>⚡ <strong>Tiết kiệm năng lượng:</strong> Công suất thấp, tuổi thọ cao</li>
<li>🔧 <strong>Dễ lắp đặt:</strong> Thiết kế plug-and-play</li>
</ul>',
    sort_order: 1
  },

  # Đèn LED gầm xe descriptions
  {
    product_id: 6,
    title: 'Đèn LED gầm xe điều khiển từ xa',
    content: '<p><strong>Bộ Đèn LED Gầm Xe AUTOLIGHT</strong> với ánh sáng mạnh mẽ và điều khiển từ xa, tạo hiệu ứng ánh sáng ấn tượng cho xe của bạn.</p>

<ul>
<li>💡 <strong>Ánh sáng mạnh mẽ:</strong> Độ sáng 6000K, tạo hiệu ứng đẹp mắt</li>
<li>📱 <strong>Điều khiển từ xa:</strong> Remote điều khiển tiện lợi</li>
<li>🔧 <strong>Dễ lắp đặt:</strong> Thiết kế đơn giản, phù hợp mọi loại xe</li>
<li>⚡ <strong>Tiết kiệm năng lượng:</strong> Công suất thấp, không ảnh hưởng ắc quy</li>
</ul>',
    sort_order: 1
  },

  # Bảo vệ gương 3M descriptions
  {
    product_id: 7,
    title: 'Bảo vệ gương chiếu hậu chống va đập',
    content: '<p><strong>Bộ Bảo Vệ Gương Chiếu Hậu 3M</strong> với chất liệu Polyurethane cao cấp, bảo vệ gương xe khỏi va đập và trầy xước.</p>

<ul>
<li>🛡️ <strong>Chống va đập:</strong> Bảo vệ gương khỏi tác động mạnh</li>
<li>🔍 <strong>Trong suốt:</strong> Không ảnh hưởng tầm nhìn</li>
<li>🧽 <strong>Dễ vệ sinh:</strong> Bề mặt mịn, dễ lau chùi</li>
<li>⚡ <strong>Độ bền cao:</strong> Không bị biến dạng theo thời gian</li>
</ul>',
    sort_order: 1
  },

  # Bảo vệ cửa WeatherTech descriptions
  {
    product_id: 8,
    title: 'Bảo vệ cửa xe chống va đập',
    content: '<p><strong>Bộ Bảo Vệ Cửa Xe WeatherTech</strong> với chất liệu Polyurethane cao cấp, bảo vệ cửa xe khỏi va đập và trầy xước.</p>

<ul>
<li>🛡️ <strong>Chống va đập:</strong> Bảo vệ cửa xe hiệu quả</li>
<li>🔧 <strong>Dễ lắp đặt:</strong> Thiết kế đơn giản, phù hợp mọi loại xe</li>
<li>🧽 <strong>Dễ vệ sinh:</strong> Bề mặt mịn, dễ lau chùi</li>
<li>⚡ <strong>Độ bền cao:</strong> Không bị biến dạng theo thời gian</li>
</ul>',
    sort_order: 1
  },

  # Loa Pioneer descriptions
  {
    product_id: 9,
    title: 'Loa xe hơi Pioneer chất lượng cao',
    content: '<p><strong>Loa Xe Hơi Pioneer TS-A1670F</strong> với công suất 50W RMS, mang đến âm thanh mạnh mẽ và chất lượng cao cho xe của bạn.</p>

<ul>
<li>🔊 <strong>Công suất cao:</strong> 50W RMS, âm thanh mạnh mẽ</li>
<li>📏 <strong>Kích thước 6.5 inch:</strong> Phù hợp hầu hết các loại xe</li>
<li>🎵 <strong>Âm thanh chất lượng:</strong> Tần số 35Hz - 22kHz</li>
<li>🔧 <strong>Dễ lắp đặt:</strong> Thiết kế tương thích với nhiều loại xe</li>
</ul>',
    sort_order: 1
  },

  # Amply Pioneer descriptions
  {
    product_id: 10,
    title: 'Amply xe hơi 4 kênh công suất cao',
    content: '<p><strong>Amply Xe Hơi Pioneer GM-D8604</strong> với 4 kênh và công suất 100W x 4, mang đến âm thanh mạnh mẽ và chất lượng cao.</p>

<ul>
<li>🔊 <strong>4 kênh:</strong> Hỗ trợ hệ thống âm thanh đa kênh</li>
<li>⚡ <strong>Công suất cao:</strong> 100W x 4 @ 4Ω</li>
<li>🔧 <strong>Dễ lắp đặt:</strong> Thiết kế compact, phù hợp mọi loại xe</li>
<li>🎵 <strong>Âm thanh chất lượng:</strong> Tín hiệu âm thanh sạch, không nhiễu</li>
</ul>',
    sort_order: 1
  }
])

# Create product videos
puts "Creating product videos..."
ProductVideo.create([
  # Camera AUTOLIGHT videos
  {
    product_id: 1,
    url: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    title: 'Đánh giá chi tiết Camera Hành Trình 4K AUTOLIGHT',
    description: 'Video review chi tiết về chất lượng hình ảnh, tính năng và cách sử dụng camera hành trình 4K AUTOLIGHT AL-2024.',
    sort_order: 1,
    is_active: true
  },
  {
    product_id: 1,  
    url: 'https://www.youtube.com/watch?v=oHg5SJYRHA0',
    title: 'Hướng dẫn cài đặt Camera Hành Trình',
    description: 'Video hướng dẫn cách cài đặt và sử dụng camera hành trình một cách đơn giản và hiệu quả.',
    sort_order: 2,
    is_active: true
  },
  
  # Camera BlackVue videos
  {
    product_id: 2,
    url: 'https://www.youtube.com/watch?v=jNQXAC9IVRw',
    title: 'BlackVue DR750X-2CH - Camera 2 kênh cao cấp',
    description: 'Đánh giá chi tiết về camera hành trình 2 kênh BlackVue với GPS và WiFi tích hợp.',
    sort_order: 1,
    is_active: true
  },
  
  # Thảm sàn Honda Civic videos
  {
    product_id: 3,
    url: 'https://www.youtube.com/watch?v=YQHsXMglC9A',
    title: 'Cách lắp đặt thảm sàn Honda Civic',
    description: 'Hướng dẫn chi tiết cách lắp đặt thảm sàn cho Honda Civic, đảm bảo vừa vặn và an toàn.',
    sort_order: 1,
    is_active: true
  },

  # Thảm sàn WeatherTech videos
  {
    product_id: 4,
    url: 'https://www.youtube.com/watch?v=fJ9rUzIMcZQ',
    title: 'WeatherTech Custom Fit - Thảm sàn cao cấp',
    description: 'Review chi tiết về thảm sàn WeatherTech với công nghệ DigitalFit™.',
    sort_order: 1,
    is_active: true
  },

  # Đèn LED nội thất videos
  {
    product_id: 5,
    url: 'https://www.youtube.com/watch?v=3AtDnEC4zak',
    title: 'Đèn LED trang trí nội thất xe - Hướng dẫn lắp đặt',
    description: 'Hướng dẫn cách lắp đặt và sử dụng đèn LED trang trí nội thất xe.',
    sort_order: 1,
    is_active: true
  },

  # Đèn LED gầm xe videos
  {
    product_id: 6,
    url: 'https://www.youtube.com/watch?v=QH2-TGUlwu4',
    title: 'Đèn LED gầm xe AUTOLIGHT - Hiệu ứng ánh sáng',
    description: 'Demo hiệu ứng ánh sáng và cách lắp đặt đèn LED gầm xe.',
    sort_order: 1,
    is_active: true
  },

  # Bảo vệ gương 3M videos
  {
    product_id: 7,
    url: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    title: 'Bảo vệ gương chiếu hậu 3M - Cách lắp đặt',
    description: 'Hướng dẫn cách lắp đặt bộ bảo vệ gương chiếu hậu 3M.',
    sort_order: 1,
    is_active: true
  },

  # Bảo vệ cửa WeatherTech videos
  {
    product_id: 8,
    url: 'https://www.youtube.com/watch?v=oHg5SJYRHA0',
    title: 'Bảo vệ cửa xe WeatherTech - Review chi tiết',
    description: 'Review chi tiết về bộ bảo vệ cửa xe WeatherTech.',
    sort_order: 1,
    is_active: true
  },

  # Loa Pioneer videos
  {
    product_id: 9,
    url: 'https://www.youtube.com/watch?v=jNQXAC9IVRw',
    title: 'Loa xe hơi Pioneer TS-A1670F - Test âm thanh',
    description: 'Test âm thanh và đánh giá chất lượng loa xe hơi Pioneer.',
    sort_order: 1,
    is_active: true
  },

  # Amply Pioneer videos
  {
    product_id: 10,
    url: 'https://www.youtube.com/watch?v=YQHsXMglC9A',
    title: 'Amply xe hơi Pioneer GM-D8604 - Hướng dẫn lắp đặt',
    description: 'Hướng dẫn cách lắp đặt và cài đặt amply xe hơi Pioneer.',
    sort_order: 1,
    is_active: true
  }
])

# Create product variants
puts "Creating product variants..."
ProductVariant.create([
  # Camera AUTOLIGHT variants
  { product_id: 1, variant_name: 'Màu sắc', variant_value: 'Đen', price_adjustment: 0, stock_quantity: 30 },
  { product_id: 1, variant_name: 'Màu sắc', variant_value: 'Trắng', price_adjustment: 100000, stock_quantity: 20 },
  
  # Camera BlackVue variants
  { product_id: 2, variant_name: 'Bộ nhớ', variant_value: '64GB', price_adjustment: 0, stock_quantity: 15 },
  { product_id: 2, variant_name: 'Bộ nhớ', variant_value: '128GB', price_adjustment: 200000, stock_quantity: 10 },
  { product_id: 2, variant_name: 'Bộ nhớ', variant_value: '256GB', price_adjustment: 400000, stock_quantity: 5 },
  
  # Thảm sàn Honda Civic variants
  { product_id: 3, variant_name: 'Kích thước', variant_value: 'Sedan', price_adjustment: 0, stock_quantity: 60 },
  { product_id: 3, variant_name: 'Kích thước', variant_value: 'Hatchback', price_adjustment: 50000, stock_quantity: 40 },
  
  # Thảm sàn WeatherTech variants
  { product_id: 4, variant_name: 'Dòng xe', variant_value: 'Honda Civic', price_adjustment: 0, stock_quantity: 40 },
  { product_id: 4, variant_name: 'Dòng xe', variant_value: 'Toyota Camry', price_adjustment: 0, stock_quantity: 35 },
  
  # Đèn LED nội thất variants
  { product_id: 5, variant_name: 'Số đèn', variant_value: '4 đèn', price_adjustment: 0, stock_quantity: 100 },
  { product_id: 5, variant_name: 'Số đèn', variant_value: '6 đèn', price_adjustment: 50000, stock_quantity: 80 },
  { product_id: 5, variant_name: 'Số đèn', variant_value: '8 đèn', price_adjustment: 100000, stock_quantity: 60 },
  
  # Đèn LED gầm xe variants
  { product_id: 6, variant_name: 'Màu sắc', variant_value: 'Trắng', price_adjustment: 0, stock_quantity: 40 },
  { product_id: 6, variant_name: 'Màu sắc', variant_value: 'Xanh dương', price_adjustment: 50000, stock_quantity: 30 },
  { product_id: 6, variant_name: 'Màu sắc', variant_value: 'Đỏ', price_adjustment: 50000, stock_quantity: 30 },
  
  # Bảo vệ gương 3M variants
  { product_id: 7, variant_name: 'Kích thước', variant_value: 'Nhỏ', price_adjustment: 0, stock_quantity: 80 },
  { product_id: 7, variant_name: 'Kích thước', variant_value: 'Trung bình', price_adjustment: 30000, stock_quantity: 50 },
  { product_id: 7, variant_name: 'Kích thước', variant_value: 'Lớn', price_adjustment: 50000, stock_quantity: 30 },
  
  # Bảo vệ cửa WeatherTech variants
  { product_id: 8, variant_name: 'Số cửa', variant_value: '2 cửa', price_adjustment: 0, stock_quantity: 60 },
  { product_id: 8, variant_name: 'Số cửa', variant_value: '4 cửa', price_adjustment: 100000, stock_quantity: 40 },
  
  # Loa Pioneer variants
  { product_id: 9, variant_name: 'Công suất', variant_value: '50W RMS', price_adjustment: 0, stock_quantity: 40 },
  { product_id: 9, variant_name: 'Công suất', variant_value: '100W RMS', price_adjustment: 200000, stock_quantity: 20 },
  
  # Amply Pioneer variants
  { product_id: 10, variant_name: 'Công suất', variant_value: '100W x 4', price_adjustment: 0, stock_quantity: 25 },
  { product_id: 10, variant_name: 'Công suất', variant_value: '150W x 4', price_adjustment: 500000, stock_quantity: 15 }
])

# Create shipping zones
puts "Creating shipping zones..."
ShippingZone.create([
  { name: 'Hà Nội', cities: ['Hà Nội'], shipping_fee: 20000, free_shipping_threshold: 500000, estimated_days: '1-2 ngày' },
  { name: 'TP. Hồ Chí Minh', cities: ['TP. Hồ Chí Minh'], shipping_fee: 20000, free_shipping_threshold: 500000, estimated_days: '1-2 ngày' },
  { name: 'Đà Nẵng', cities: ['Đà Nẵng'], shipping_fee: 30000, free_shipping_threshold: 800000, estimated_days: '2-3 ngày' },
  { name: 'Các tỉnh khác', cities: ['Hải Phòng', 'Cần Thơ', 'Nghệ An', 'Thanh Hóa'], shipping_fee: 50000, free_shipping_threshold: 1000000, estimated_days: '3-5 ngày' }
])

# Create stores
puts "Creating stores..."
Store.create([
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
Coupon.create([
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
articles = Article.create([
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
    category: 'Phụ Kiện Ô Tô',
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
  },
  {
    title: 'Đèn LED trang trí xe - Xu hướng mới 2024',
    slug: 'den-led-trang-tri-xe-xu-huong-moi-2024',
    excerpt: 'Khám phá xu hướng sử dụng đèn LED trang trí xe hơi để tạo phong cách cá nhân và nâng cao tính thẩm mỹ.',
    content: 'Đèn LED trang trí xe hơi đang trở thành xu hướng mới trong giới chơi xe...',
    featured_image: '/images/articles/den-led-trang-tri.jpg',
    author: 'Mexe Team',
    category: 'Phụ Kiện Ô Tô',
    tags: ['đèn LED', 'trang trí', 'thẩm mỹ', 'xu hướng'],
    status: 'published',
    published_at: Time.current - 2.days,
    view_count: 720
  },
  {
    title: 'Hệ thống âm thanh xe hơi - Hướng dẫn nâng cấp',
    slug: 'he-thong-am-thanh-xe-hoi-huong-dan-nang-cap',
    excerpt: 'Hướng dẫn chi tiết cách nâng cấp hệ thống âm thanh xe hơi để có trải nghiệm âm nhạc tuyệt vời.',
    content: 'Hệ thống âm thanh xe hơi chất lượng cao không chỉ mang đến trải nghiệm âm nhạc tuyệt vời...',
    featured_image: '/images/articles/am-thanh-xe-hoi.jpg',
    author: 'Mexe Team',
    category: 'Phụ Kiện Ô Tô',
    tags: ['âm thanh', 'loa', 'amply', 'nâng cấp'],
    status: 'published',
    published_at: Time.current - 4.days,
    view_count: 650
  }
])

# Create article images
puts "Creating article images..."
ArticleImage.create([
  { article_id: 1, image_url: '/images/articles/top-10-phu-kien-1.jpg', alt_text: 'Camera hành trình', caption: 'Camera hành trình bảo vệ quyền lợi', sort_order: 1 },
  { article_id: 1, image_url: '/images/articles/top-10-phu-kien-2.jpg', alt_text: 'Thảm sàn ô tô', caption: 'Thảm sàn bảo vệ sàn xe', sort_order: 2 },
  { article_id: 2, image_url: '/images/articles/camera-hanh-trinh-1.jpg', alt_text: 'Camera 4K', caption: 'Chất lượng hình ảnh 4K', sort_order: 1 },
  { article_id: 2, image_url: '/images/articles/camera-hanh-trinh-2.jpg', alt_text: 'Góc nhìn rộng', caption: 'Góc nhìn 170°', sort_order: 2 },
  { article_id: 3, image_url: '/images/articles/tham-san-1.jpg', alt_text: 'Thảm cao su', caption: 'Thảm cao su chống trượt', sort_order: 1 },
  { article_id: 3, image_url: '/images/articles/tham-san-2.jpg', alt_text: 'Thảm nylon', caption: 'Thảm nylon dễ vệ sinh', sort_order: 2 },
  { article_id: 4, image_url: '/images/articles/den-led-1.jpg', alt_text: 'Đèn LED nội thất', caption: 'Đèn LED trang trí nội thất xe', sort_order: 1 },
  { article_id: 4, image_url: '/images/articles/den-led-2.jpg', alt_text: 'Đèn LED gầm xe', caption: 'Đèn LED gầm xe ấn tượng', sort_order: 2 },
  { article_id: 5, image_url: '/images/articles/am-thanh-1.jpg', alt_text: 'Loa xe hơi', caption: 'Loa xe hơi chất lượng cao', sort_order: 1 },
  { article_id: 5, image_url: '/images/articles/am-thanh-2.jpg', alt_text: 'Amply xe hơi', caption: 'Amply xe hơi công suất cao', sort_order: 2 }
])

puts "Database seeding completed successfully!"
puts "Created:"
puts "- #{Setting.count} settings"
puts "- #{Category.count} categories"
puts "- #{Brand.count} brands"
puts "- #{Product.count} products"
puts "- #{ProductSpecification.count} product specifications"
puts "- #{ProductDescription.count} product descriptions"
puts "- #{ProductVideo.count} product videos"
puts "- #{ProductImage.count} product images"
puts "- #{ProductVariant.count} product variants"
puts "- #{ShippingZone.count} shipping zones"
puts "- #{Store.count} stores"
puts "- #{Coupon.count} coupons"
puts "- #{Article.count} articles"
puts "- #{ArticleImage.count} article images"

# Admin users already created above for client_id assignment

# Set early order tab flags
puts "Setting early order tab flags..."
# Trending products (Dự án thịnh hành)
Product.where(is_hot: true).or(Product.where(is_essential_accessories: true)).update_all(is_trending: true)

# New products (Mới ra mắt) - already has is_new flag
puts "New products: #{Product.where(is_new: true).count}"

# Ending soon products (Sắp kết thúc) - set some products as ending soon
Product.where(is_preorder: true).update_all(is_ending_soon: true)
Product.where(id: [1, 3, 5]).update_all(is_ending_soon: true) # Some specific products

# Arriving soon products (Sắp về hàng) - set some products as arriving soon
Product.where(id: [2, 4, 6, 8]).update_all(is_arriving_soon: true) # Some specific products

# Best seller products (Bán chạy nhất) - set some products as best sellers
Product.where(id: [1, 2, 3, 4, 5, 6]).update_all(is_best_seller: true) # Some specific products

puts "Early order tab flags set:"
puts "- Trending: #{Product.where(is_trending: true).count}"
puts "- New: #{Product.where(is_new: true).count}"
puts "- Ending soon: #{Product.where(is_ending_soon: true).count}"
puts "- Arriving soon: #{Product.where(is_arriving_soon: true).count}"
puts "- Best seller: #{Product.where(is_best_seller: true).count}"

puts "Admin users created:"
puts "- Super Admin: admin@mexe.com / password123"
puts "- Client 1: client1@mexe.com / password123 (#{client1.client_name})"
puts "- Client 2: client2@mexe.com / password123 (#{client2.client_name})"

# Create users for testing
puts "Creating test users..."
user1 = User.find_or_create_by(email: 'user1@test.com') do |user|
  user.full_name = 'Nguyễn Văn A'
  user.phone = '0912345678'
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.address = '123 Nguyễn Huệ, Quận 1, TP.HCM'
  user.is_active = true
end

user2 = User.find_or_create_by(email: 'user2@test.com') do |user|
  user.full_name = 'Trần Thị B'
  user.phone = '0987654321'
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.address = '456 Lê Lợi, Quận 3, TP.HCM'
  user.is_active = true
end

# Create sample orders
puts "Creating sample orders..."
orders = []

# Order 1 - Logged in user
order1 = Order.find_or_create_by(order_number: 'ORD-20250906-001') do |order|
  order.user = user1
  order.status = 'confirmed'
  order.payment_method = 'cod'
  order.payment_status = 'pending'
  order.delivery_type = 'home'
  order.delivery_address = '123 Nguyễn Huệ, Quận 1, TP.HCM'
  order.shipping_name = 'Nguyễn Văn A'
  order.shipping_phone = '0912345678'
  order.shipping_city = 'TP. Hồ Chí Minh'
  order.shipping_district = 'Quận 1'
  order.shipping_ward = 'Phường Bến Nghé'
  order.subtotal = 0
  order.total_amount = 0
end

# Order 2 - Guest user  
order2 = Order.find_or_create_by(order_number: 'ORD-20250906-002') do |order|
  order.guest_name = 'Lê Văn C'
  order.guest_email = 'levanc@guest.com'
  order.guest_phone = '0909876543'
  order.status = 'pending'
  order.payment_method = 'cod'
  order.payment_status = 'pending'
  order.delivery_type = 'home'
  order.delivery_address = '789 Điện Biên Phủ, Quận 3, TP.HCM'
  order.shipping_name = 'Lê Văn C'
  order.shipping_phone = '0909876543'
  order.shipping_city = 'TP. Hồ Chí Minh'
  order.shipping_district = 'Quận 3'
  order.shipping_ward = 'Phường 1'
  order.subtotal = 0
  order.total_amount = 0
end

# Order 3 - Another logged in user
order3 = Order.find_or_create_by(order_number: 'ORD-20250906-003') do |order|
  order.user = user2
  order.status = 'processing'
  order.payment_method = 'cod'
  order.payment_status = 'pending'
  order.delivery_type = 'home'
  order.delivery_address = '456 Lê Lợi, Quận 3, TP.HCM'
  order.shipping_name = 'Trần Thị B'
  order.shipping_phone = '0987654321'
  order.shipping_city = 'TP. Hồ Chí Minh'
  order.shipping_district = 'Quận 3'
  order.shipping_ward = 'Phường 6'
  order.subtotal = 0
  order.total_amount = 0
end

orders = [order1, order2, order3]

# Create order items for each order
puts "Creating order items..."

# Order 1 items (products from both clients)
if Product.exists?(1) && Product.exists?(3)
  OrderItem.find_or_create_by(order: order1, product_id: 1) do |item|
    item.product_name = 'Camera Hành Trình 4K AUTOLIGHT AL-2024'
    item.product_sku = 'CAM-AL-2024'
    item.quantity = 1
    item.unit_price = 2500000
    item.total_price = 2500000
  end
  
  OrderItem.find_or_create_by(order: order1, product_id: 3) do |item|
    item.product_name = 'Thảm Sàn Ô Tô Cao Cấp Honda Civic'
    item.product_sku = 'THAM-HC-001'
    item.quantity = 1
    item.unit_price = 850000
    item.total_price = 850000
  end
end

# Order 2 items (client1 products)
if Product.exists?(5) && Product.exists?(6)
  OrderItem.find_or_create_by(order: order2, product_id: 5) do |item|
    item.product_name = 'Đèn LED Trang Trí Nội Thất Xe'
    item.product_sku = 'DEN-LED-001'
    item.quantity = 2
    item.unit_price = 350000
    item.total_price = 700000
  end
  
  OrderItem.find_or_create_by(order: order2, product_id: 6) do |item|
    item.product_name = 'Bộ Đèn LED Gầm Xe AUTOLIGHT'
    item.product_sku = 'DEN-GAM-001'
    item.quantity = 1
    item.unit_price = 800000
    item.total_price = 800000
  end
end

# Order 3 items (client2 products)
if Product.exists?(4)
  OrderItem.find_or_create_by(order: order3, product_id: 4) do |item|
    item.product_name = 'Thảm Sàn WeatherTech Custom Fit'
    item.product_sku = 'THAM-WT-001'
    item.quantity = 1
    item.unit_price = 1200000
    item.total_price = 1200000
  end
end

# Calculate totals for each order
orders.each do |order|
  order.calculate_totals
  order.save!
end

# Manually trigger client notifications after order items are created
puts "Creating client notifications..."
orders.each do |order|
  order.send(:notify_clients_about_new_order)
end

# Create user_order_info records
puts "Creating user order info records..."
UserOrderInfo.find_or_create_by(order: order1) do |info|
  info.buyer_name = 'Nguyễn Văn A'
  info.buyer_email = 'user1@test.com'
  info.buyer_phone = '0912345678'
  info.buyer_address = '123 Nguyễn Huệ, Quận 1'
  info.buyer_city = 'TP. Hồ Chí Minh'
  info.notes = 'Giao hàng trong giờ hành chính'
end

UserOrderInfo.find_or_create_by(order: order2) do |info|
  info.buyer_name = 'Lê Văn C'
  info.buyer_email = 'levanc@guest.com'
  info.buyer_phone = '0909876543'
  info.buyer_address = '789 Điện Biên Phủ, Quận 3'
  info.buyer_city = 'TP. Hồ Chí Minh'
  info.notes = 'Để hàng với bảo vệ nếu không có người'
end

UserOrderInfo.find_or_create_by(order: order3) do |info|
  info.buyer_name = 'Trần Thị B'
  info.buyer_email = 'user2@test.com'
  info.buyer_phone = '0987654321'
  info.buyer_address = '456 Lê Lợi, Quận 3'
  info.buyer_city = 'TP. Hồ Chí Minh'
  info.notes = 'Gọi trước khi giao'
end

# Client notifications are now created automatically via callback

puts "\nSample data created successfully!"
puts "Created:"
puts "- #{User.count} test users"
puts "- #{Order.count} sample orders"
puts "- #{OrderItem.count} order items"
puts "- #{UserOrderInfo.count} user order info records"
puts "- #{ClientNotification.count} client notifications"

puts "\nTest Users:"
puts "- user1@test.com / password123 (Nguyễn Văn A)"
puts "- user2@test.com / password123 (Trần Thị B)"

puts "\nClient Notifications Summary:"
puts "- Client 1 (AUTOLIGHT): #{ClientNotification.where(admin_user: client1).count} notifications (#{ClientNotification.where(admin_user: client1, is_read: false).count} unread)"
puts "- Client 2 (Honda Parts): #{ClientNotification.where(admin_user: client2).count} notifications (#{ClientNotification.where(admin_user: client2, is_read: false).count} unread)"
