module MessageHandler

  def check_if_message
    if params[:micropost][:content][0..1] == 'd '
      save_micropost_as_message
    end
  end

  def save_micropost_as_message
    text           = params[:micropost][:content]
    recipient_id   = get_recipient_id(text)
    content        = remove_recipient_stub(text).strip
    # message_params = { to: recipient.id, content: content }
    # There is something wrong with this line:

    message = current_user.messages.build(to: recipient_id, content: content)
    if message.save
      redirect_to root_url,
        flash: { success: "Message sent to #{User.find(recipient_id).name}."}
    else
      redirect_to root_url, flash: { error: "Error: Either the username is
        invalid or content was blank." }
    end
  end


  private

    def get_recipient_id(text)
      target_username = text.slice(/\Ad\s\b(\w|-|\.)+/i)[2..-1]
      recipient = User.find_by(username: target_username)
      recipient.nil? ? '' : recipient.id
    end

    def remove_recipient_stub(text)
      # strip off 'd username '
      text.tap { |s| s.slice!(/\Ad\s\b(\w|-|\.)+/i) }
    end
end
