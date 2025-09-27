namespace :db do
  desc "Simple import Vietnamese administrative units data"
  task simple_import_vn_units: :environment do
    puts "Importing Vietnamese administrative units data..."
    
    # Disable foreign key checks
    ActiveRecord::Base.connection.execute("SET FOREIGN_KEY_CHECKS = 0")
    
    # Clear existing data
    ActiveRecord::Base.connection.execute("DELETE FROM wards")
    ActiveRecord::Base.connection.execute("DELETE FROM provinces") 
    ActiveRecord::Base.connection.execute("DELETE FROM administrative_units")
    ActiveRecord::Base.connection.execute("DELETE FROM administrative_regions")
    
    # Import administrative_regions
    puts "Importing administrative_regions..."
    ActiveRecord::Base.connection.execute(
      "INSERT INTO administrative_regions (id, name, name_en, code_name, code_name_en, created_at, updated_at) VALUES " +
      "(1,'Đông Bắc Bộ','Northeast','dong_bac_bo','northest', NOW(), NOW())," +
      "(2,'Tây Bắc Bộ','Northwest','tay_bac_bo','northwest', NOW(), NOW())," +
      "(3,'Đồng bằng sông Hồng','Red River Delta','dong_bang_song_hong','red_river_delta', NOW(), NOW())," +
      "(4,'Bắc Trung Bộ','North Central Coast','bac_trung_bo','north_central_coast', NOW(), NOW())," +
      "(5,'Duyên hải Nam Trung Bộ','South Central Coast','duyen_hai_nam_trung_bo','south_central_coast', NOW(), NOW())," +
      "(6,'Tây Nguyên','Central Highlands','tay_nguyen','central_highlands', NOW(), NOW())," +
      "(7,'Đông Nam Bộ','Southeast','dong_nam_bo','southeast', NOW(), NOW())," +
      "(8,'Đồng bằng sông Cửu Long','Mekong River Delta','dong_bang_song_cuu_long','southwest', NOW(), NOW())"
    )
    
    # Import administrative_units
    puts "Importing administrative_units..."
    ActiveRecord::Base.connection.execute(
      "INSERT INTO administrative_units (id, full_name, full_name_en, short_name, short_name_en, code_name, code_name_en, created_at, updated_at) VALUES " +
      "(1,'Thành phố trực thuộc trung ương','Municipality','Thành phố','City','thanh_pho_truc_thuoc_trung_uong','municipality', NOW(), NOW())," +
      "(2,'Tỉnh','Province','Tỉnh','Province','tinh','province', NOW(), NOW())," +
      "(3,'Phường','Ward','Phường','Ward','phuong','ward', NOW(), NOW())," +
      "(4,'Xã','Commune','Xã','Commune','xa','commune', NOW(), NOW())," +
      "(5,'Đặc khu tại hải đảo','Special administrative region','Đặc khu','Special administrative region','dac_khu','special_administrative_region', NOW(), NOW())"
    )
    
    # Import provinces from file content
    puts "Importing provinces..."
    file_content = File.read(Rails.root.join('db', 'master_data_vn_units.sql'))
    
    # Extract provinces section
    provinces_match = file_content.match(/INSERT INTO provinces\(code,name,name_en,full_name,full_name_en,code_name,administrative_unit_id\) VALUES\s+(.+?);/m)
    if provinces_match
      provinces_values = provinces_match[1]
      
      # Convert to proper INSERT with timestamps
      sql = "INSERT INTO provinces (code, name, name_en, full_name, full_name_en, code_name, administrative_unit_id, created_at, updated_at) VALUES "
      
      # Split records and add timestamps to each
      records = provinces_values.split(/\),\s*\(/)
      modified_records = []
      
      records.each_with_index do |record, index|
        if index == 0
          record = record.gsub(/^\(/, '') # Remove leading parenthesis
        end
        if index == records.length - 1
          record = record.gsub(/\)$/, '') # Remove trailing parenthesis
        end
        
        modified_records << "(#{record}, NOW(), NOW())"
      end
      
      sql += modified_records.join(", ")
      
      begin
        ActiveRecord::Base.connection.execute(sql)
        puts "Successfully imported #{records.length} provinces"
      rescue => e
        puts "Error importing provinces: #{e.message}"
      end
    end
    
    # Import wards - process in batches due to large size
    puts "Importing wards..."
    wards_match = file_content.match(/INSERT INTO wards\(code,name,name_en,full_name,full_name_en,code_name,province_code,administrative_unit_id\) VALUES\s+(.+)$/m)
    if wards_match
      wards_content = wards_match[1]
      
      # Remove the trailing semicolon and split into individual records
      wards_content = wards_content.gsub(/;$/, '')
      records = wards_content.split(/\),\s*\(/)
      
      puts "Processing #{records.length} wards in batches..."
      
      batch_size = 100
      records.each_slice(batch_size).with_index do |batch, batch_index|
        puts "Processing batch #{batch_index + 1}/#{(records.length.to_f / batch_size).ceil}"
        
        modified_records = []
        batch.each_with_index do |record, index|
          # Clean up the record
          if batch_index == 0 && index == 0
            record = record.gsub(/^\(/, '') # Remove leading parenthesis from very first record
          end
          if batch_index == (records.length.to_f / batch_size).ceil - 1 && index == batch.length - 1
            record = record.gsub(/\)$/, '') # Remove trailing parenthesis from very last record
          end
          
          modified_records << "(#{record}, NOW(), NOW())"
        end
        
        sql = "INSERT INTO wards (code, name, name_en, full_name, full_name_en, code_name, province_code, administrative_unit_id, created_at, updated_at) VALUES " + modified_records.join(", ")
        
        begin
          ActiveRecord::Base.connection.execute(sql)
        rescue => e
          puts "Error in batch #{batch_index + 1}: #{e.message}"
        end
      end
    end
    
    # Re-enable foreign key checks
    ActiveRecord::Base.connection.execute("SET FOREIGN_KEY_CHECKS = 1")
    
    puts "Import completed successfully!"
    puts "Administrative Regions: #{ActiveRecord::Base.connection.execute('SELECT COUNT(*) FROM administrative_regions').first[0]}"
    puts "Administrative Units: #{ActiveRecord::Base.connection.execute('SELECT COUNT(*) FROM administrative_units').first[0]}"
    puts "Provinces: #{ActiveRecord::Base.connection.execute('SELECT COUNT(*) FROM provinces').first[0]}"
    puts "Wards: #{ActiveRecord::Base.connection.execute('SELECT COUNT(*) FROM wards').first[0]}"
  end
end
