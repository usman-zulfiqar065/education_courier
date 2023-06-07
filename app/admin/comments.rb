index_block = proc do
  index do
    selectable_column
    id_column
    column :user
    column('Blog') { |comment| link_to comment.blog.id, admin_blog_path(comment.blog) }
    column :content
    column :parent_comment do |comment|
      comment.parent.present? && (link_to comment.parent.id, admin_user_comment_path(comment.parent))
    end
    column('Likes Count') { |comment| comment.likes.count }
    column :created_at
    actions if current_user.admin?
  end
end

show_comment_details = proc do
  panel 'Comment Details' do
    attributes_table_for user_comment do
      row :user
      row :blog
      row :content
      row :parent do |comment|
        link_to comment.parent.id, admin_user_comment_path(comment.parent) if comment.parent.present?
      end
      row('comment replies') { |comment| comment.children.count }
      row('comment likes') { |comment| comment.likes.count }
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

filter_block = proc do
  filter :user
  filter :content
  filter :created_at
end

scope_block = proc do
  scope 'All Comments', :all
  scope 'Todays Comments', :created_today
end

show_block = proc do
  show do
    tabs do
      tab :comment_details do
        instance_eval(&show_comment_details)
      end
      tab :comment_replies do
        instance_eval(&show_comment_replies_pannel)
      end
      tab :comment_likes do
        instance_eval(&show_comment_likes_pannel)
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

ActiveAdmin.register Comment, as: 'UserComment' do
  scope_to :current_user, association_method: :blog_comments
  permit_params :content, :user_id, :blog_id

  instance_eval(&index_block)
  instance_eval(&show_block)
  instance_eval(&scope_block)
  instance_eval(&filter_block)
  instance_eval(&form_block)
  instance_eval(&controller_block)
end
