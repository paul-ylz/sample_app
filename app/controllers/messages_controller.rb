class MessagesController < ApplicationController

  before_action :signed_in_user
  before_action :set_message, only: [:show, :destroy]
  before_action :correct_user, only: [:show, :destroy]
  before_action :set_message_counts

  def index
    @messages = current_user.received_messages
  end

  def show
  end

  def new
    @message = Message.new
  end

  def create
    @message = current_user.messages.build(message_params)

    if @message.save
      redirect_to root_url, flash: { success: 'Message sent' }
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

  def reply
    @message_to_reply = Message.find(params[:id])
    @message = current_user.messages.build(to: @message_to_reply.from)
    render 'new'
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

    def set_message_counts
      @inbox_count ||= current_user.received_messages.size
    end

end
