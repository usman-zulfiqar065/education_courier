class CreateLikes < ActiveRecord::Migration[7.0]
  def change
    create_table :likes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :likeable, polymorphic: true, null: false
      t.index %i[user_id likeable_type likeable_id], unique: true

      t.timestamps
    end
  end
end
