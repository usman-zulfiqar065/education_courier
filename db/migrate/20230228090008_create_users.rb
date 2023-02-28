class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, default: ''
      t.integer :role, default: 0
      t.string :email, null: false

      t.timestamps
    end
  end
end
