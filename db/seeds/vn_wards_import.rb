# Import wards data
puts "Importing wards data..."

# Delete existing wards
ActiveRecord::Base.connection.execute("DELETE FROM wards")

file_content = File.read(Rails.root.join('db', 'master_data_vn_units.sql'))

# Extract the wards section more carefully
wards_start = file_content.index("-- DATA for wards --")
if wards_start
  wards_section = file_content[wards_start..-1]
  
  # Split into lines and process each line that contains ward data
  lines = wards_section.split("\n")
  ward_records = []
  
  lines.each do |line|
    # Match lines that contain ward data records
    if line.match(/^\('(\d+)','([^']+)','([^']+)','([^']+)','([^']+)','([^']+)','(\d+)',(\d+)\),?$/)
      matches = line.scan(/\('(\d+)','([^']+)','([^']+)','([^']+)','([^']+)','([^']+)','(\d+)',(\d+)\)/)
      ward_records.concat(matches)
    end
  end
  
  puts "Found #{ward_records.length} ward records to import"
  
  # Import in batches
  ward_records.each_slice(100).with_index do |batch, batch_index|
    puts "Processing batch #{batch_index + 1}/#{(ward_records.length.to_f / 100).ceil}"
    
    values = []
    batch.each do |record|
      code = record[0]
      name = ActiveRecord::Base.connection.quote(record[1])
      name_en = ActiveRecord::Base.connection.quote(record[2])
      full_name = ActiveRecord::Base.connection.quote(record[3])
      full_name_en = ActiveRecord::Base.connection.quote(record[4])
      code_name = ActiveRecord::Base.connection.quote(record[5])
      province_code = record[6]
      admin_unit_id = record[7]
      
      values << "(#{code}, #{name}, #{name_en}, #{full_name}, #{full_name_en}, #{code_name}, '#{province_code}', #{admin_unit_id}, NOW(), NOW())"
    end
    
    if values.any?
      sql = "INSERT INTO wards (code, name, name_en, full_name, full_name_en, code_name, province_code, administrative_unit_id, created_at, updated_at) VALUES #{values.join(', ')}"
      
      begin
        ActiveRecord::Base.connection.execute(sql)
        puts "Successfully imported batch #{batch_index + 1}"
      rescue => e
        puts "Error in batch #{batch_index + 1}: #{e.message}"
        # Try individual inserts for this batch
        batch.each do |record|
          begin
            code = record[0]
            name = ActiveRecord::Base.connection.quote(record[1])
            name_en = ActiveRecord::Base.connection.quote(record[2])
            full_name = ActiveRecord::Base.connection.quote(record[3])
            full_name_en = ActiveRecord::Base.connection.quote(record[4])
            code_name = ActiveRecord::Base.connection.quote(record[5])
            province_code = record[6]
            admin_unit_id = record[7]
            
            individual_sql = "INSERT INTO wards (code, name, name_en, full_name, full_name_en, code_name, province_code, administrative_unit_id, created_at, updated_at) VALUES (#{code}, #{name}, #{name_en}, #{full_name}, #{full_name_en}, #{code_name}, '#{province_code}', #{admin_unit_id}, NOW(), NOW())"
            ActiveRecord::Base.connection.execute(individual_sql)
          rescue => individual_error
            puts "Error importing ward #{record[0]}: #{individual_error.message}"
          end
        end
      end
    end
  end
end

total_wards = ActiveRecord::Base.connection.execute("SELECT COUNT(*) FROM wards").first[0]
puts "Import completed! Total wards: #{total_wards}"
