class MessagesController < ApplicationController

	before_action :signed_in_user
	before_action :set_message, only: [:show, :destroy]
	before_action :correct_user, only: [:show, :destroy]

	def index
		@messages = current_user.received_messages
		@count = @messages.size
	end

	def show 
	end

	def new
		@reply_to = params[:to]
	end

	def create
		if current_user.messages.create(message_params)
			redirect_to root_url, flash: { success: "Reply sent" }
		else
			render 'new'
		end
	end

	def destroy
		if @message.destroy
			redirect_to messages_url, flash: { success: 'Message deleted' }
		end
	end

	def sent 
		@messages = current_user.messages
	end

	private

		def message_params
			params.require(:message).permit(:to, :content)
		end

		def set_message
			@message = Message.find(params[:id])
		end

		def correct_user
			redirect_to root_url unless (current_user.id == @message.from) || (current_user.id == @message.to)
		end

end				