class User < ActiveRecord::Base
	before_save { self.email = email.downcase }

	validates :name, presence: true, length: { maximum: 50 }

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, 
		uniqueness: { case_sensitive: false }
	# Tutorial suggests that model validation will not prevent a duplicate email
	# from being saved if 'Submit' is accidentally clicked twice, thus validation
	# must go a step further and be implemented at the database level by creating
	# an index on the email column and requiring the index to be unique.
	# 
	# $ rails g migration add_index_to_users_email
	# 
	# -inside migration-
	# def change
	# 	add_index :users, :email, unique: true
	# end

	validates :password, length: { minimum: 6 }

	# has_secure_password requires bcrypt-ruby gem and automagically creates 
	# password and password_confirmation attributes. It requires a password_digest 
	# column to be created in the db.
	has_secure_password
end
