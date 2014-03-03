class AddSignupConfirmationToUser < ActiveRecord::Migration
  def change
    add_column :users, :active, :boolean, default: false
    add_column :users, :email_verification_token, :string
  end
end
