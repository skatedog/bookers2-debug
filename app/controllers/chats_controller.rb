class ChatsController < ApplicationController
  before_action :ensure_follow_each_other?, only: :show

  def show
    @user = User.find(params[:id])
    room_ids = current_user.rooms.ids
    @room = @user.rooms.find_by(id: room_ids)

    if @room
      @chats = @room.chats
    else
      @room = Room.new
      @room.save
      @chats = @room.chats.new
      @chats.save
      current_user.user_rooms.create(room_id: @room.id)
      @user.user_rooms.create(room_id: @room.id)
    end

    @chat = @room.chats.new
  end

  def create
    @chat = current_user.chats.new(chat_params)
    @chat.save
  end

  private

  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end

  def ensure_follow_each_other?
    @user = User.find(params[:id])
    unless current_user.follow_each_other?(@user)
      redirect_to books_path
    end
  end
end
