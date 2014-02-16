class AddAdminToUsers < ActiveRecord::Migration
  def change
  	# ensure admin defaults to false!
    add_column :users, :admin, :boolean, default: false
  end
end
