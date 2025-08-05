namespace :admin do
  desc "Create admin user"
  task create_user: :environment do
    email = 'admin@mexe.com'
    password = 'password123'
    
    if AdminUser.exists?(email: email)
      puts "Admin user with email #{email} already exists!"
    else
      AdminUser.create!(
        email: email,
        password: password,
        password_confirmation: password
      )
      puts "Admin user created successfully!"
      puts "Email: #{email}"
      puts "Password: #{password}"
    end
  end
end 