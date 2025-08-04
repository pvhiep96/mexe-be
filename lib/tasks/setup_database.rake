namespace :db do
  desc "Setup database with all migrations and seeds"
  task setup_all: :environment do
    puts "Starting database setup..."
    
    # Drop database if exists
    puts "Dropping database if exists..."
    Rake::Task['db:drop'].invoke rescue nil
    
    # Create database
    puts "Creating database..."
    Rake::Task['db:create'].invoke
    
    # Run all migrations
    puts "Running migrations..."
    Rake::Task['db:migrate'].invoke
    
    # Load seeds
    puts "Loading seeds..."
    Rake::Task['db:seed'].invoke
    
    puts "Database setup completed successfully!"
  end

  desc "Reset database (drop, create, migrate, seed)"
  task reset: :environment do
    puts "Resetting database..."
    
    # Drop database
    puts "Dropping database..."
    Rake::Task['db:drop'].invoke rescue nil
    
    # Create database
    puts "Creating database..."
    Rake::Task['db:create'].invoke
    
    # Run migrations
    puts "Running migrations..."
    Rake::Task['db:migrate'].invoke
    
    # Load seeds
    puts "Loading seeds..."
    Rake::Task['db:seed'].invoke
    
    puts "Database reset completed successfully!"
  end
end 