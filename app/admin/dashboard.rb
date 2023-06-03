parent_comment_block = proc do
  column :parent do |comment|
    if current_user.admin? && comment.parent.present?
      link_to comment.parent.id, admin_user_comment_path(comment.parent)
    elsif comment.parent.present?
      comment.parent.content
    end
  end
end

comment_blog_block = proc do
  column :blog do |comment|
    if current_user.admin? || comment.blog.user == current_user
      link_to comment.blog.title admin_blog_path(blog)
    else
      comment.blog.title
    end
  end
end

comment_user_block = proc do
  column :user do |comment|
    current_user.admin? && (link_to comment.user.name admin_user_comment_path(comment)) || comment.user.name
  end
end

comment_id_block = proc do
  column :id do |comment|
    current_user.admin? && (link_to comment.id, admin_user_comment_path(comment)) || comment.id
  end
end

like_likeable_block = proc do
  column :likeable do |like|
    if like.likeable_type == 'Blog'
      current_user.admin? && (link_to like.likeable_type, admin_blog_path(like.likeable)) || like.likeable.title
    else
      current_user.admin? && (link_to like.likeable_type, admin_user_comment_path(like.likeable)) || like.likeable.content
    end
  end
end

like_user_block = proc do
  column :user do |like|
    current_user.admin? && (link_to like.user.name, admin_user_path(like.user)) || like.user.name
  end
end

states_pannel_block = proc do
  attributes_table_for('todays_status') do
    row('Total Blogs') { current_user.admin_dashboard_blogs.created_today.count }
    row('Total Comments') { current_user.blog_comments.created_today.count }
    row('Total Blog Likes') {Like.dashboard_status(current_user, 'Blog').created_today.count}
    row('Total Comment Likes') {Like.dashboard_status(current_user, 'Comment').created_today.count}
  end
end

blogs_pannel_block = proc do
  panel "Today's Blogs" do
    table_for current_user.admin_dashboard_blogs.created_today do
      column :id
      column('title') { |blog| link_to blog.title, admin_blog_path(blog) }
      column :status if current_user.admin?
      column :user
      column :created_at
      column('Likes Count') { |blog| blog.likes.count }
      column('Comments Count') { |blog| blog.comments.count }
    end
  end
end

comments_pannel_block = proc do
  panel "Today's Comments" do
    table_for current_user.blog_comments.created_today do
      instance_eval(&comment_id_block)
      instance_eval(&comment_user_block)
      column :content
      instance_eval(&comment_blog_block)
      instance_eval(&parent_comment_block)
      column :created_at
    end
  end
end

likes_pannel_block = proc do
  panel "Today's Likes" do
    table_for current_user.blog_likes.created_today do
      column :id
      instance_eval(&like_user_block)
      instance_eval(&like_likeable_block)
      column :created_at
    end
  end
end

ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    tabs do
      tab :todays_status do
        instance_eval(&states_pannel_block)
      end
      tab :todays_blogs do
        instance_eval(&blogs_pannel_block)
      end
      tab :todays_comments do
        instance_eval(&comments_pannel_block)
      end
      tab :todays_likes do
        instance_eval(&likes_pannel_block)
      end
    end
  end
end
