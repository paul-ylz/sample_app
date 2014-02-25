module MessageHandler

	def check_if_message
		if params[:micropost][:content][0..1] == "d "
			save_micropost_as_message
		end
	end

	def save_micropost_as_message
		text           = params[:micropost][:content]
		recipient      = get_message_recipient(text)
		content        = remove_recipient_stub(text).strip
		# message_params = { to: recipient.id, content: content }
		# There is something wrong with this line:

		message = current_user.messages.build(to: recipient.id, content: content)
		if message.save 
			redirect_to root_url, 
				flash: { success: "Message sent to #{recipient.username}."}
		else
			redirect_to root_url, flash: { error: 'dude an error' }
		end
	end


	private 

		def get_message_recipient(text)
			target_username = text.slice(/\Ad\s\b(\w|-|\.)+/i)[2..-1]
			User.find_by(username: target_username)
		end

		def remove_recipient_stub(text)
			# strip off 'd username '
			text.tap { |s| s.slice!(/\Ad\s\b(\w|-|\.)+/i) }
		end
		
end