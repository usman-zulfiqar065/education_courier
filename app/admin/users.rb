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

show_user_blogs = proc do
  panel 'User Blogs' do
    table_for user.blogs do
      column 'Blog id' do |blog|
        link_to blog.id, admin_blog_path(blog)
      end
      column :title
      column :created_at
      column :published_at
      column :status
      column :category
    end
  end
end

scope_block = proc do
  scope 'All Users', :all
  scope 'Active Users', :active
  scope 'Admins', :admin
  scope 'Bloggers', :blogger
  scope 'Creators Team', :creator
end

show_attributes_block = proc do
  attributes_table do
    row('User Image') { |user| image_tag user.user_avatar, width: 100, height: 80 }
    row :id if current_user.admin?
    row :name
    row :email
    row :role
    attributes_table_for user.user_summary do
      row :title
      row :twitter
      row :github
      row :linked_in
    end
    row('Blogs Count') { |user| user.blogs.count } if user.blogger?
    row :created_at
  end
end

show_block = proc do
  show do
    tabs do
      tab :user_details do
        instance_eval(&show_attributes_block)
      end
      if user.blogger?
        tab :user_blogs do
          instance_eval(&show_user_blogs)
        end
      end
    end
  end
end

controller_block = proc do
  controller do
    def action_methods
      current_user.admin? && super || super - %w[edit update destroy]
    end
  end
end

find_resource_block = proc do
  controller do
    def find_resource
      if resource_class.is_a?(FriendlyId)
        scoped_collection.friendly.find(params[:id])
      else
        scoped_collection.find(params[:id])
      end
    end
  end
end

ActiveAdmin.register User do
  menu if: proc { current_user.admin? }
  permit_params :name, :email, :role, :password, :password_confirmation

  instance_eval(&filter_block)
  instance_eval(&index_block)
  instance_eval(&scope_block)
  instance_eval(&form_block)
  instance_eval(&show_block)
  instance_eval(&controller_block)
  instance_eval(&find_resource_block)
end
