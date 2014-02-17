class CreateMicroposts < ActiveRecord::Migration
  def change
    create_table :microposts do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
    # Chap 10.1 Use a multiple key index because posts will be retrieved
    # for a given user in chronological order
    add_index :microposts, [:user_id, :created_at]
  end
end
