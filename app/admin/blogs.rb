ActiveAdmin.register Blog do
  permit_params :category, :title, :status, :slug, :read_time

  index do
    selectable_column
    id_column
    column :title
    column :status
    column :published_at
    column :user
    column :category
    actions
  end

  scope 'All Blogs', :all
  scope 'Published Blogs', :published
  scope 'Scheduled Blogs', :scheduled
  scope 'Draft Blogs', :draft

  filter :user
  filter :category
  filter :title
  filter :status, filters: [:equals]
  filter :slug
  filter :published_at
  filter :read_time
  filter :created_at

  form do |f|
    f.inputs do
      f.input :category
      f.input :title
      f.input :status
      f.input :slug
      f.input :read_time
    end
    f.actions
  end
end
