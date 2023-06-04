filter_block = proc do
  filter :user
  filter :category
  filter :title
  filter :status, filters: [:equals]
  filter :tags
  filter :published_at
  filter :read_time
  filter :created_at
end

index_block = proc do
  index do
    selectable_column
    id_column
    column :title
    column :status if current_user.admin?
    column :published_at
    column('Likes Count') { |blog| blog.likes.count }
    column('Comments Count') { |blog| blog.comments.count }
    column :user
    column :category
    actions
  end
end

scope_block = proc do
  scope 'All Blogs', :all
  scope 'Todays Blogs', :created_today
  scope 'Published Blogs', :published
  scope 'Scheduled Blogs', :scheduled
  scope 'Draft Blogs', :draft
end

form_block = proc do
  form do |f|
    f.inputs do
      f.input :category
      f.input :title
      f.input :status if current_user.admin?
      f.input :tags
      f.input :read_time
      f.input :video_link
      f.input :avatar, as: :file
      f.input :published_at
    end
    f.actions
  end
end

show_attributes_block = proc do
  attributes_table do
    row('Blog Image') { |blog| image_tag blog.blog_avatar, width: 100, height: 80 }
    row('id') { |blog| link_to 'Show on web', blog_path(blog) }
    row :title
    row :video_link
    row :summary
    row :status if current_user.admin?
    row :tags
    row :published_at
    row :read_time
    row :user
    row('category') do |category|
      current_user.admin? && (link_to category.title, admin_category_path(category)) || category.title
    end
    row('comments_count') { |blog| blog.comments.count }
    row('likes_count') { |blog| blog.likes.count }
    row :created_at
    row :updated_at
  end
end

show_comments_panel = proc do
  panel 'Blog Comments' do
    table_for blog.comments do
      column :id
      column :user
      column :content
      column 'Parent Comment' do |comment|
        link_to comment.parent.id, admin_user_comment_path(comment.parent) if comment.parent.present?
      end
      column('Likes Count') { |comment| comment.likes.count }
      column :created_at
    end
  end
end

show_likes_panel = proc do
  panel 'Blog Likes' do
    table_for blog.likes do
      column :id
      column :user
      column :created_at
    end
  end
end

show_block = proc do
  show do
    tabs do
      tab :blog_details do
        instance_eval(&show_attributes_block)
      end
      tab :blog_comments do
        instance_eval(&show_comments_panel)
      end
      tab :blog_likes do
        instance_eval(&show_likes_panel)
      end
    end
  end
end

controller_block = proc do
  controller do
    def scoped_collection
      if params[:action] == 'index' && !current_user.admin?
        super
      else
        Blog.all
      end
    end
  end
end

ActiveAdmin.register Blog do
  scope_to :current_user, unless: proc { current_user.admin? }, only: :index

  permit_params :category, :title, :status, :tags, :read_time, :video_link, :published_at, :avatar

  instance_eval(&index_block)
  instance_eval(&show_block)
  instance_eval(&scope_block)
  instance_eval(&filter_block)
  instance_eval(&form_block)
  instance_eval(&controller_block)
end
