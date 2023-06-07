class CreateUserSummaries < ActiveRecord::Migration[7.0]
  def change
    create_table :user_summaries do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.string :twitter
      t.string :linked_in
      t.string :github

      t.timestamps
    end
  end
end
