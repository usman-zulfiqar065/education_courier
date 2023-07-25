namespace :users do
  desc 'Create admin user'
  task create_admin: :environment do
    puts 'Creating admin account'

    admin_user = User.admin.find_or_initialize_by(name: 'Muhammad Usman', email: 'education.courier.team@gmail.com')
    admin_user.password = '123456'
    admin_user.password_confirmation = '123456'
    admin_user.save
    puts 'Admin created with email education.courier.team@gmail.com'

    puts 'Done ....'
    puts 'Email sent to respective accounts, Please Confirm your email address'
  end
end
