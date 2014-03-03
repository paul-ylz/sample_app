class AddIndexToEmailVerificationTokenToUsers < ActiveRecord::Migration
  def change
  	add_index :users, :email_verification_token, unique: true
  end

end
