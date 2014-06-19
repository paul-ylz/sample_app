class Micropost < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate :active_user

  default_scope         -> { order(created_at: :desc) }
  scope :feed_for_user, -> (user) { feed_for_user(feed) }

  private
    # Return microposts from the users being followed by the given user.
    def self.feed_for_user(user)
      followed_user_ids = "SELECT followed_id
                           FROM relationships
                           WHERE follower_id = :user_id"

      where("user_id IN (#{followed_user_ids}) OR user_id = :user_id OR in_reply_to = :user_id",
       user_id: user)
    end

    def active_user
      unless self.user.active?
        errors[:base] << 'Please confirm your email before posting'
      end
    end
end
