class CreateVietnameseAdministrativeUnits < ActiveRecord::Migration[7.2]
  def change
    # Bảng administrative_regions - 8 vùng địa lý Việt Nam
    create_table :administrative_regions, id: :integer do |t|
      t.string :name, null: false, limit: 255
      t.string :name_en, null: false, limit: 255
      t.string :code_name, null: false, limit: 255
      t.string :code_name_en, null: false, limit: 255
      t.timestamps
    end

    # Bảng administrative_units - Các đơn vị hành chính
    create_table :administrative_units, id: :integer do |t|
      t.string :full_name, null: false, limit: 255
      t.string :full_name_en, null: false, limit: 255
      t.string :short_name, null: false, limit: 255
      t.string :short_name_en, null: false, limit: 255
      t.string :code_name, null: false, limit: 255
      t.string :code_name_en, null: false, limit: 255
      t.timestamps
    end

    # Bảng provinces - Tỉnh/Thành phố trực thuộc trung ương
    create_table :provinces, id: false do |t|
      t.string :code, null: false, limit: 20, primary_key: true
      t.string :name, null: false, limit: 255
      t.string :name_en, null: false, limit: 255
      t.string :full_name, null: false, limit: 255
      t.string :full_name_en, null: false, limit: 255
      t.string :code_name, null: false, limit: 255
      t.integer :administrative_unit_id, null: false
      t.timestamps
    end

    # Bảng wards - Phường/Xã/Thị trấn
    create_table :wards, id: false do |t|
      t.string :code, null: false, limit: 20, primary_key: true
      t.string :name, null: false, limit: 255
      t.string :name_en, null: false, limit: 255
      t.string :full_name, null: false, limit: 255
      t.string :full_name_en, null: false, limit: 255
      t.string :code_name, null: false, limit: 255
      t.string :province_code, null: false, limit: 20
      t.integer :administrative_unit_id, null: false
      t.timestamps
    end

    # Thêm indexes và foreign keys
    add_index :provinces, :administrative_unit_id
    add_index :wards, :province_code
    add_index :wards, :administrative_unit_id

    # Foreign key constraints
    add_foreign_key :provinces, :administrative_units, column: :administrative_unit_id
    add_foreign_key :wards, :provinces, column: :province_code, primary_key: :code
    add_foreign_key :wards, :administrative_units, column: :administrative_unit_id
  end
end
