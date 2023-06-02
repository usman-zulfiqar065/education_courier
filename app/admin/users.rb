filter_block = proc do
  filter :name
  filter :role, filters: [:equals]
  filter :email
  filter :created_at
end

index_block = proc do
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
end

form_block = proc do
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
end

show_block = proc do
  show do
    panel 'User Blogs' do
      table_for user.blogs do
        column 'Blog id' do |blog|
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
end

sidebar_block = proc do
  sidebar 'User Details', only: :show do
    attributes_table_for user do
      row :id
      row :name
      row :email
      row :role
    end
  end
end

ActiveAdmin.register User do
  menu if: proc { current_user.admin? }
  permit_params :name, :email, :role, :password, :password_confirmation

  instance_eval(&filter_block)
  instance_eval(&index_block)

  scope 'Active Users', :active

  instance_eval(&form_block)
  instance_eval(&show_block)
  instance_eval(&sidebar_block)
end
