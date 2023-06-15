namespace :users do
  desc 'Create admin user'
  task create_admin: :environment do
    puts 'Creating owner and admin account'

    owner = User.owner.find_or_initialize_by(name: 'Usman Zulfiqar', email: 'usman.zulfiqar065@gmail.com')
    owner.password = '123456'
    owner.password_confirmation = '123456'
    owner.save
    owner.create_user_summary(title: 'Product Owner')
    puts 'Owner Account created with email usman.zulfiqar065@gmail.com'

    admin_user = User.admin.find_or_initialize_by(name: 'Muhammad Usman', email: 'education.courier.team@gmail.com')
    admin_user.password = '123456'
    admin_user.password_confirmation = '123456'
    admin_user.save
    puts 'Admin created with email education.courier.team@gmail.com'

    puts 'Done ....'
    puts 'Email sent to respective accounts, Please Confirm your email address'
  end
end
