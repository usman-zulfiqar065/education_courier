ActiveAdmin.register Category do
  permit_params :name

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
      row :id
      row :name
      row :created_at
    end
  end
end
