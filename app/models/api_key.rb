class ApiKey < ActiveRecord::Base
  belongs_to :user
  validates :user_id, numericality: { only_integer: true }

  before_create :generate_access_token

  private

  def generate_access_token
    begin
      self.access_token = SecureRandom.hex
    end while self.class.exists?(access_token: access_token)
  end
end
