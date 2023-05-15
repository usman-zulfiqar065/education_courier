class CreateBlogs < ActiveRecord::Migration[7.0]
  def change
    create_table :blogs do |t|
      t.string :title, null: false
      t.string :video_link, null: true
      t.text :summary, null: false
      t.text :content, null: false
      t.integer :status, null: false, default: 0
      t.string :slug, null: false
      t.datetime :published_at, null: true
      t.float :read_time, null: false, default: 1
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
