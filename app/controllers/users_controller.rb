class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :show, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :find_user, except: [:index, :new, :create]

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

  private

  def find_user
    @user = User.find_by id: params[:id]

    render file: "public/404.html", layout: false unless @user
  end

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t ".pls_login"
      redirect_to login_url
    end
  end

  def correct_user
    @user = User.find_by id: params[:id]

    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.is_admin?
  end
end
