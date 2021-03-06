class MessagesController < ApplicationController
  def create
    if Entry.where(user_id: current_user.id, room_id: params[:message][:room_id]).present?
      @message = Message.create(params.require(:message).permit(:user_id, :content,
                                                                :room_id).merge(user_id: current_user.id))
      message_users = @message.room.entries
      user = message_users.select {|user| user['user_id'] != current_user.id}
      user = user.entries[0]
      current_user.create_notification_dm!(current_user, user.user_id)
      redirect_to "/rooms/#{@message.room_id}"
    else
      flash[:danger] = 'ユーザーが削除されました'
      redirect_to root_path
    end
  end

  def destroy
    message = Message.find(params[:id])
      if message.destroy
        redirect_back(fallback_location: root_path)
      else
        flash[:danger] = 'ユーザーが削除されました'
        redirect_to root_path
      end
  end

  private

  def message_params
    params.require(:message).permit(:room_id, :content)
  end
end
