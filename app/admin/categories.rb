ActiveAdmin.register Category do
  menu if: proc { current_user.admin? }
  permit_params :name, :avatar

  index do
    selectable_column
    id_column
    column :name
    column :created_at
    column('Blogs Count') { |category| category.blogs.count }
    actions
  end

  filter :name
  filter :created_at

  show do
    attributes_table do
      row('Category Image') do |category|
        image_tag category.category_avatar, width: 100, height: 80
      end
      row :id
      row :name
      row :created_at
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :avatar, as: :file
    end
    f.actions
  end
end
