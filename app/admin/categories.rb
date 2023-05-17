ActiveAdmin.register Category do
  permit_params :name

  index do
    selectable_column
    id_column
    column :name
    column :created_at
    column 'Blogs Count' do |category|
      category.blogs.count
    end
    actions
  end

  filter :name
  filter :created_at
end
