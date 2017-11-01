class CreateChores < ActiveRecord::Migration
  def change
    create_table :chores do |t|
      t.string :name
      t.string :frequency
      t.string :status
      t.datetime :reset_day
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
