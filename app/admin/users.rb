ActiveAdmin.register User do
  permit_params :name, :email, :role, :password, :password_confirmation

  filter :name
  filter :role, filters: [:equals]
  filter :email
  filter :created_at

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :role
    column :created_at
    column :confirmed_at
    actions
  end

  scope 'Active Users', :active

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :role
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  show do
    panel 'User Blogs' do
      table_for user.blogs do
        column 'id' do |blog|
          link_to blog.id, admin_blog_path
        end
        column :title
        column :created_at
        column :published_at
        column :status
        column :category
      end
    end
  end

  sidebar 'User Details', only: :show do
    attributes_table_for user do
      row :name
      row :email
      row :role
    end
  end
end
