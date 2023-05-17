ActiveAdmin.register Comment, as: 'UserComment' do
  index do
    selectable_column
    id_column
    column :user
    column 'Blog' do |comment|
      link_to comment.blog.id, admin_blog_path(comment.blog)
    end
    column :content
    column 'Parent Comment' do |comment|
      link_to comment.parent.id, admin_user_comment_path(comment.parent) if comment.parent.present?
    end
    column 'Likes Count' do |comment|
      comment.likes.count
    end
    column :created_at
    actions
  end

  filter :user
  filter :content
  filter :created_at

  show do
    panel "Comment's Children" do
      table_for user_comment.children do
        column 'id' do |c|
          link_to c.id, admin_user_comment_path(c)
        end
        column :user
        column :content
        column :created_at
      end
    end
  end

  sidebar 'Comment Details', only: :show do
    attributes_table_for user_comment do
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
