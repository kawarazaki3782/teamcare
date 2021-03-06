class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[index edit destroy following followers]
  before_action :guest_user, only: :edit
  before_action :correct_user, only: :edit
  before_action :admin_user, only: :destroy
  before_action :blocking_user, only: :show
  before_action :set_user, only: %i[show verification destroy update following followers blocking]
  

  def show
    if logged_in? && current_user.id.to_s == params[:id]
      @micropost = @user.micropost_ids
      @diary = @user.diary_ids
      @rooms = @user.rooms
      @current_user_entry = Entry.where(user_id: current_user.id)
      @user_entry = Entry.where(user_id: @user.id)
      @current_user_entry.each do |cu|
        @user_entry.each do |u|
          if cu.room_id == u.room_id
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      if @isRoom
      else
        @room = Room.new
        @entry = Entry.new
      end

    end
    if logged_in? && current_user.id.to_s != params[:id]
      begin
        @microposts = @user.microposts.order(created_at: :desc).page(params[:page]).per(3)
        @diaries = @user.diaries.order(created_at: :desc).page(params[:page]).per(3)
        @current_user_entry = Entry.where(user_id: current_user.id)
        @user_entry = Entry.where(user_id: @user.id)
        @current_user_entry.each do |cu|
          @user_entry.each do |u|
            if cu.room_id == u.room_id
              @isRoom = true
              @roomId = cu.room_id
            end
          end
        end
        if @isRoom
        else
          @room = Room.new
          @entry = Entry.new
        end
      end
    end
    rescue ActiveRecord::RecordNotFound => e
      flash[:danger] = 'ユーザーが削除されました'
      redirect_to root_path
    end
    
  def new
    @user = User.new
  end

  def confirm
    @user = User.new(user_params)
    render 'new' if @user.invalid?
  end

  def destroy
    flash[:danger] = if @user.destroy
                       'ユーザーを削除しました'
                     else
                       'ユーザーを削除できませんでした'
                     end
    redirect_to users_url
  end

  def create
    @user = User.new(user_params)
    unless @user.profile_image.file
      @user.profile_image = Pathname.new(Rails.root.join("images/default.jpg")).open
    end
    if params[:back]
      render 'new'
    elsif params[:save]
      @user.save
      log_in @user
      flash[:success] = '新規登録が完了しました'
      redirect_to @user
    else
      flash[:danger] = 'ユーザーを登録できませんでした'
      render 'new'
    end
  end

  def edit; end

  def verification
    @user.attributes = user_params
    @user.profile_image.cache!
    if params[:back]
      render 'edit'
      return
    end
    unless @user.valid?
      render 'edit'
      return
    end
    if params[:save]
      @user.profile_image.retrieve_from_cache! params[:cache][:profile_image]
      if @user.update(user_params)
        flash[:success] = "プロフィールの編集が完了しました"
        redirect_to action: 'update'
      else
        flash[:danger] = 'ユーザーを編集できませんでした'
        render 'edit'
      end
    end
  end

  def update; end

  def index
    @users = User.all.page(params[:page]).per(5)
  end

  def following
    @users = @user.following.page(params[:page]).per(5)
    render 'show_followed'
  end

  def followers
    @users = @user.followers.page(params[:page]).per(5)
    render 'show_follower'
  end

  def blocking
    @users = @user.blocking.page(params[:page]).per(5)
    render 'show_blocking'
  end

  def help
    @user = current_user
    current_user.create_notification_help!
    flash[:success] = '全利用者に通知を送りました'
    render 'show'
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :profile_image, :password, :password_confirmation, :gender, :birthday,
                                 :address, :long_teamcare, :profile, :profile_image_cache)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def set_user
    @user = User.find(params[:id])
  end
end
