# frozen_string_literal: true

ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    panel "Today's States" do
      para "Total Blogs: #{Blog.created_today.count}"
      para "Total Comments: #{Comment.created_today.count}"
      para "Total Blog likes: #{Like.created_today.where(likeable_type: 'Blog').count}"
      para "Total Comment likes: #{Like.created_today.where(likeable_type: 'Comment').count}"
    end
    columns do
      column do
        panel "Today's Blogs" do
          table_for Blog.created_today do
            column :id
            column :title do |blog|
              link_to blog.title, admin_blog_path(blog)
            end
            column :status
            column :user
            column :created_at
            column 'Likes Count' do |blog|
              blog.likes.count
            end
            column 'Comments Count' do |blog|
              blog.comments.count
            end
          end
        end
      end
    end

    panel 'Todays Comments' do
      table_for Comment.created_today do
        column 'id' do |c|
          link_to c.id, admin_user_comment_path(c)
        end
        column :user
        column :content
        column :blog
        column :parent do |comment|
          link_to comment.parent.id, admin_user_comment_path(comment.parent) if comment.parent.present?
        end
        column :created_at
      end
    end

    panel 'Todays Likes' do
      table_for Like.created_today do
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
end
