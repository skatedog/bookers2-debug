class GroupsController < ApplicationController
  def index
    @book = Book.new
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
  end

  def email_form
    @group = Group.find(params[:group_id])
    unless @group.owner_id == current_user.id
      redirect_to group_path(params[:group_id])
    end
  end

  def send_event_email
    email_addresses = Group.find(params[:group_id]).users.map { |user| user.email }
    @title = params[:title]
    @content = params[:content]
    GroupMailer.send_email(email_addresses,@title,@content).deliver_now
  end

  def new
    @group = Group.new
    @group.owner_id = current_user.id
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      GroupUser.create(user_id: current_user.id,group_id: @group.id)
      redirect_to groups_path
    else
      render :new
    end
  end

  def edit
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to group_path(params[:id])
    end
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      redirect_to group_path(params[:id])
    else
      render :edit
    end
  end

  private
  def group_params
    params.require(:group).permit(:name, :introduction, :image, :owner_id)
  end
end
