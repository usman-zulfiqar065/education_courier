ActiveAdmin.register Like do
  permit_params :user_id, :likeable_id, :likeable_type
  index do
    selectable_column
    id_column
    column :user
    column 'Likeable' do |like|
      if like.likeable_type == 'Blog'
        link_to like.likeable_type, admin_blog_path(like.likeable)
      else
        link_to like.likeable_type, admin_user_comment_path(like.likeable)
      end
    end
    column :created_at
    actions
  end

  filter :likeable_type, label: 'Liked object'
  filter :user
  filter :created_at

  form do |f|
    f.inputs do
      f.input :user
      f.input :likeable_type, as: :select, collection: %w[Blog Comment]
      f.input :likeable_id
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :user
      row :likeable do |like|
        if like.likeable_type == 'Blog'
          link_to like.likeable_type, admin_blog_path(like.likeable)
        else
          link_to like.likeable_type, admin_user_comment_path(like.likeable)
        end
      end
      row :created_at
    end
  end
end
