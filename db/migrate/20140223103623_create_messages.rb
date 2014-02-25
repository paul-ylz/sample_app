class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :from
      t.integer :to
      t.text :content

      t.timestamps
    end
    add_index :messages, :from
    add_index :messages, :to
  end
end
