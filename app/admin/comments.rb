ActiveAdmin.register Comment, as: 'UserComment' do
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

  scope 'All Comments', :all
  scope 'Todays Comments', :created_today

  filter :user
  filter :content
  filter :created_at

  show do
    panel 'Comment Replies' do
      table_for user_comment.children do
        column('id') { |c| link_to c.id, admin_user_comment_path(c) }
        column :user
        column :content
        column :created_at
      end
    end

    panel 'Comment Likes' do
      table_for user_comment.likes do
        column :id
        column :user
        column :created_at
      end
    end
  end

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

  form do |f|
    f.inputs do
      f.input :user
      f.input :blog
      f.input :content
    end
    f.actions
  end
end
