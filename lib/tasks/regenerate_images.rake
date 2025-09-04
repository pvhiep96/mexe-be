namespace :images do
  desc "Regenerate all product image versions"
  task regenerate: :environment do
    puts "Starting to regenerate product image versions..."
    
    ProductImage.find_each do |product_image|
      if product_image.image.present?
        begin
          puts "Regenerating versions for ProductImage ##{product_image.id}..."
          product_image.image.recreate_versions!
          puts "✅ Successfully regenerated versions for ProductImage ##{product_image.id}"
        rescue => e
          puts "❌ Error regenerating ProductImage ##{product_image.id}: #{e.message}"
        end
      else
        puts "⚠️  ProductImage ##{product_image.id} has no image attached"
      end
    end
    
    puts "Image regeneration completed!"
  end
end
