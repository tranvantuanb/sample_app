class UsersController < ApplicationController
  before_action :verify_user, except: [:new, :create, :show]
  before_action :correct_user, only: [:edit, :update]
  before_action :verify_admin, only: :destroy
  before_action :load_user, except: [:new, :index, :create]

  def index
    @users = User.select(:name, :email, :id)
      .paginate(page: params[:page], per_page: Settings.page_size).order "name ASC"
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t ".welcome_new_user"
      redirect_to @user
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".profile_updated"
      redirect_to @user
    else
      flash.now[:danger] = t ".update_failed"
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = t ".user_deleted"
    redirect_to users_url
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def verify_user
    unless logged_in?
      store_location
      flash[:danger] = t ".please_log_in"
      redirect_to login_url
    end
  end

  def correct_user
    load_user
    redirect_to root_url unless current_user? @user
  end

  def verify_admin
    redirect_to root_url unless current_user.admin?
  end

  def load_user
    @user = User.find_by id: params[:id]
    render_404 unless @user
  end
end
