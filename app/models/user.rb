class User < ActiveRecord::Base
	
	# Ex 6.5.2 Adding a bang! to the end of an object's method will assign the   
	# modified object to itself. 
	# 
	before_save { self.email.downcase! }
	before_create :create_remember_token
	has_many :microposts, dependent: :destroy
	
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	has_many :followed_users, through: :relationships, source: :followed

	has_many :reverse_relationships, foreign_key: "followed_id", 
		class_name: "Relationship", dependent: :destroy

	# Chap 11: source: follower can be omitted, since Rails will infer a source
	# of :follower and hence look up follower_id in this case.
	# 
	has_many :followers, through: :reverse_relationships#, source: :follower

	validates :name, presence: true, length: { maximum: 50 }

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
	# 
	VALID_EMAIL_REGEX =	/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, 
		uniqueness: { case_sensitive: false }

	
	validates :password, length: { minimum: 6 }
	# has_secure_password requires bcrypt-ruby gem and automagically creates 
	# password and password_confirmation attributes. It requires a password_digest 
	# column to be created in the db.
	# 
	has_secure_password


	VALID_USERNAME_REGEX = /\A(\w|-|\.)+\z/i
	validates :username, presence: true, length: { maximum: 15 }, 
		format: { with: VALID_USERNAME_REGEX }, uniqueness: true

	# Chap 8.18
	# Token creation and encrption are called on User because they are not specific 
	# to a particular user instance. Further they are public because we use them 
	# from outside the User model too.
	# 
	# Create a random string and encrypt it for use as a remember token, which will
	# be stored in both the app database and browser cookie to use for authentication
	# and remembrance.
	# 
	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.encrypt(token)
		# Call .to_s in case of nil tokens (should not happen in browsers, but 
		# could happen in tests)
		# 
		Digest::SHA1.hexdigest(token.to_s)
	end

	def feed
		Micropost.where("user_id = ?", id)
	end

	def follow(user)
		self.relationships.create(followed_id: user.id)
	end

	def following?(other_user)
		self.relationships.find_by(followed_id: other_user.id)
	end

	def follow!(other_user)
		self.relationships.create!(followed_id: other_user.id)
	end

	def unfollow!(other_user)
		self.relationships.find_by(followed_id: other_user.id).destroy
	end

	def feed 
		Micropost.from_users_followed_by(self)
	end

	private

		def create_remember_token
			self.remember_token = User.encrypt(User.new_remember_token)
		end
end
