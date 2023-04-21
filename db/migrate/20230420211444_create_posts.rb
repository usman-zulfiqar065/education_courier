class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.string :video_link
      t.text :summary, null: false
      t.text :content, null: false
      t.integer :status, null: false
      t.string :slug, null: false

      t.timestamps
    end
  end
end
