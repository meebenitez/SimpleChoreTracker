class CreateChores < ActiveRecord::Migration
  def change
    create_table :chores do |t|
      t.string :name
      t.string :frequency
      t.string :status
      t.datetime :reset_time
      t.integer :user_id
      t.boolean :past_due

      t.timestamps null: false
    end
  end
end
