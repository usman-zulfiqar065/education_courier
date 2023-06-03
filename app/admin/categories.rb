index_block = proc do
  index do
    selectable_column
    id_column
    column :name
    column :created_at
    column('Blogs Count') { |category| category.blogs.count }
    actions
  end
end

show_block = proc do
  show do
    attributes_table do
      row('Category Image') do |category|
        image_tag category.category_avatar, width: 100, height: 80
      end
      row :id
      row :name
      row('blogs_count') { |category| category.blogs.count }
      row :created_at
    end
  end
end

form_block = proc do
  form do |f|
    f.inputs do
      f.input :name
      f.input :avatar, as: :file
    end
    f.actions
  end
end

filter_block = proc do
  filter :name
  filter :created_at
end

controller_block = proc do
  controller do
    def action_methods
      current_user.admin? && super || super - %w[edit update destroy]
    end
  end
end

ActiveAdmin.register Category do
  menu if: proc { current_user.admin? }
  permit_params :name, :avatar

  instance_eval(&index_block)
  instance_eval(&show_block)
  instance_eval(&form_block)
  instance_eval(&filter_block)
  instance_eval(&controller_block)
end
