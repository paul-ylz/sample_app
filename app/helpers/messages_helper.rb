module MessagesHelper 

	def delete_message
		'Warning: Your recipient will be unable to view the message if you delete it. Are you sure?'
	end

	def shorten(string, max)
		if string.length > max
			string[0..max] + "...."
		else
			string
		end
	end
end