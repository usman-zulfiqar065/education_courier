namespace :users do
  desc 'Create admin user'
  task create_admin: :environment do
    puts 'Creating admin user'

    user = User.admin.find_or_initialize_by(name: 'Usman Zulfiqar', email: 'usman.zulfiqar065@gmail.com')
    user.password = '123456'
    user.password_confirmation = '123456'
    user.save

    puts 'Admin created'
  end
end
