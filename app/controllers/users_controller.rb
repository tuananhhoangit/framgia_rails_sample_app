class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :show, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :verify_admin, only: :destroy
  before_action :load_user, except: [:index, :new, :create]

  def index
    @users = User.select(:id, :name, :email).order(id: :asc)
      .paginate page: params[:page], per_page: Settings.user.per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:info] = t ".check_mail"
      redirect_to root_url
    else
      flash.now[:danger] = t ".error"
      render :new
    end
  end

  def show
    @microposts = @user.microposts.select(:id, :content, :picture, :user_id, :created_at)
      .order(created_at: :desc).paginate page: params[:page]
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".profile_updated"
      redirect_to @user
    else
      flash.now[:danger] = t ".update_fail"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".user_deleted"
    else
      flash[:danger] = t ".fail_to_delete"
    end
    redirect_to users_url
  end

  def following
    @title = t ".following"
    @users = @user.following.select(:id, :email, :name).order(id: :asc)
      .paginate page: params[:page]
    render :show_follow
  end

  def followers
    @title = t ".followers"
    @users = @user.followers.select(:id, :email, :name).order(id: :asc)
      .paginate page: params[:page]
    render :show_follow
  end

  private

  def load_user
    @user = User.find_by id: params[:id]

    valid_info @user
  end

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  def correct_user
    @user = User.find_by id: params[:id]

    redirect_to root_url unless current_user? @user
  end

  def verify_admin
    redirect_to root_url unless current_user.is_admin?
  end
end
