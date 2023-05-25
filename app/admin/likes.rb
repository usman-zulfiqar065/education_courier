index_block = proc do
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
end

show_block = proc do
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

form_block = proc do
  form do |f|
    f.inputs do
      f.input :user
      f.input :likeable_type, as: :select, collection: %w[Blog Comment]
      f.input :likeable_id
    end
    f.actions
  end
end

filter_block = proc do
  filter :likeable_type, label: 'Liked object'
  filter :user
  filter :created_at
end

ActiveAdmin.register Like do
  permit_params :user_id, :likeable_id, :likeable_type

  instance_eval(&index_block)
  instance_eval(&filter_block)
  instance_eval(&form_block)
  instance_eval(&show_block)
end
