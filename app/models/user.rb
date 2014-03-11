
class User < ActiveRecord::Base
	
	# Using the pg_search gem to use Postgresql's full-text-search capabilities
	# See https://github.com/Casecommons/pg_search
	#
	include PgSearch
	pg_search_scope :search_name_and_username, 
		against: [:name, :username, :email],
		using: {
			tsearch: { prefix: true, any_word: true } 
		}

	# Ex 6.5.2 Adding a bang! to the end of an object's method will assign the   
	# modified object to itself. 
	# 
	before_save { self.email.downcase! }
	before_create :create_remember_token, :create_email_verification_token

	has_many :microposts, dependent: :destroy
	
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	has_many :followed_users, through: :relationships, source: :followed

	has_many :reverse_relationships, foreign_key: "followed_id", 
		class_name: "Relationship", dependent: :destroy

	# Chap 11: source: follower can be omitted, since Rails will infer a source
	# of :follower and hence look up follower_id in this case.
	# 
	has_many :followers, through: :reverse_relationships#, source: :follower
	
	has_many :messages, foreign_key: "from"
	has_many :received_messages, foreign_key: "to", class_name: "Message"

	has_one :api_key

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

	# def follow(user)
	# 	self.relationships.create(followed_id: user.id)
	# end

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
		Micropost.feed_for_user(self)
	end

	def send_follower_notification(follower)
		UserMailer.follower_notification(self, follower).deliver if notifications?
	end

	def send_password_reset
		update_attribute(:password_reset_token, User.new_remember_token)
		update_attribute(:password_reset_sent_at, Time.zone.now)
		UserMailer.password_reset(self).deliver
	end

	def invalidate_password_reset
		update_attribute(:password_reset_token, nil)
	end

	def send_email_confirmation
		UserMailer.email_confirmation(self).deliver
	end

	def set_active
		update_attribute(:active, true)
	end

	def self.search(query)
		if query.present?
			search_name_and_username(query)
		else
			where(nil)
		end
	end

	private

		def create_email_verification_token
			self.email_verification_token = User.new_remember_token
		end

		def create_remember_token
			self.remember_token = User.encrypt(User.new_remember_token)
		end

end
