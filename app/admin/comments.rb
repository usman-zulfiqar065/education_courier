index_block = proc do
  index do
    selectable_column
    id_column
    column :user
    column('Blog') { |comment| link_to comment.blog.id, admin_blog_path(comment.blog) }
    column :content
    column 'Parent Comment' do |comment|
      link_to comment.parent.id, admin_user_comment_path(comment.parent) if comment.parent.present?
    end
    column('Likes Count') { |comment| comment.likes.count }
    column :created_at
    actions
  end
end

sidebar_block = proc do
  sidebar 'Comment Details', only: :show do
    attributes_table_for user_comment do
      row :id
      row :user
      row :blog
      row :content
      row :parent do |comment|
        link_to comment.parent.id, admin_user_comment_path(comment.parent) if comment.parent.present?
      end
      row :created_at
    end
  end
end

form_block = proc do
  form do |f|
    f.inputs do
      f.input :user
      f.input :blog
      f.input :content
    end
    f.actions
  end
end

show_comment_replies_pannel = proc do
  panel 'Comment Replies' do
    table_for user_comment.children do
      column('id') { |c| link_to c.id, admin_user_comment_path(c) }
      column :user
      column :content
      column :created_at
    end
  end
end

show_comment_likes_pannel = proc do
  panel 'Comment Likes' do
    table_for user_comment.likes do
      column :id
      column :user
      column :created_at
    end
  end
end

ActiveAdmin.register Comment, as: 'UserComment' do
  permit_params :content, :user_id, :blog_id
  instance_eval(&index_block)

  scope 'All Comments', :all
  scope 'Todays Comments', :created_today

  filter :user
  filter :content
  filter :created_at

  show do
    instance_eval(&show_comment_replies_pannel)
    instance_eval(&show_comment_likes_pannel)
  end

  instance_eval(&sidebar_block)

  instance_eval(&form_block)
end
