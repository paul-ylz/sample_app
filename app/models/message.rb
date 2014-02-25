class Message < ActiveRecord::Base
	
	belongs_to :sender, class_name: "User", foreign_key: "from"
	belongs_to :recipient, class_name: "User", foreign_key: "to"

	validates :content, presence: true, length: { maximum: 160 }
	validates :from, presence: true, numericality: { only_integer: true }
	validates :to, presence: true, numericality: { only_integer: true }
end
