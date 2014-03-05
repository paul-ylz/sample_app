class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.integer :user_id
      t.string :access_token

      t.timestamps
    end
    add_index :api_keys, :access_token, unique: true
    add_index :api_keys, :user_id, unique: true
  end
end
