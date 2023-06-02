states_pannel_block = proc do
  panel "Today's States" do
    para "Total Blogs: #{current_user.admin_dashboard_blogs.created_today.count}"
    para "Total Comments: #{current_user.blog_comments.created_today.count}"
    para "Total Blog likes: #{Like.dashboard_status(current_user, 'Blog').created_today.count}"
    para "Total Comment likes: #{Like.dashboard_status(current_user, 'Comment').created_today.count}"
  end
end

blogs_pannel_block = proc do
  columns do
    column do
      panel "Today's Blogs" do
        table_for current_user.admin_dashboard_blogs.created_today do
          column :id
          column('title') { |blog| link_to blog.title, admin_blog_path(blog) }
          column :status
          column :user
          column :created_at
          column('Likes Count') { |blog| blog.likes.count }
          column('Comments Count') { |blog| blog.comments.count }
        end
      end
    end
  end
end

comments_pannel_block = proc do
  panel "Today's Comments" do
    table_for current_user.blog_comments.created_today do
      column('id') { |c| link_to c.id, admin_user_comment_path(c) }
      column :user
      column :content
      column :blog
      column :parent do |comment|
        link_to comment.parent.id, admin_user_comment_path(comment.parent) if comment.parent.present?
      end
      column :created_at
    end
  end
end

likes_pannel_block = proc do
  panel "Today's Likes" do
    table_for current_user.blog_likes.created_today do
      column :id
      column :user
      column :likeable do |like|
        if like.likeable_type == 'Blog'
          link_to like.likeable_type, admin_blog_path(like.likeable)
        else
          link_to like.likeable_type, admin_user_comment_path(like.likeable)
        end
      end
      column :created_at
    end
  end
end

ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    instance_eval(&states_pannel_block)
    instance_eval(&blogs_pannel_block)
    instance_eval(&comments_pannel_block)
    instance_eval(&likes_pannel_block)
  end
end
