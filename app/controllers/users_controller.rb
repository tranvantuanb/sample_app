class UsersController < ApplicationController
  before_action :verify_user, except: [:new, :create, :show]
  before_action :correct_user, only: [:edit, :update]
  before_action :verify_admin, only: :destroy
  before_action :load_user, except: [:new, :index, :create]

  def index
    @users = User.select(:name, :email, :id)
      .paginate(page: params[:page], per_page: Settings.page_size)
      .order t ".order"
  end

  def show
    @microposts = @user.microposts.paginate page: params[:page]
    @followed_id = current_user.active_relationships.find_by followed_id: @user.id
    @active_relationships_build = current_user.active_relationships.build
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".please_check_email"
      redirect_to root_url
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

  def following
    @title = t ".following"
    @user = User.find_by id: params[:id]
    @users = @user.following.paginate page: params[:page]
    render "show_follow"
  end

  def followers
    @title = t ".followers"
    @user = User.find_by id: params[:id]
    @users = @user.followers.paginate page: params[:page]
    render "show_follow"
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def load_user
    @user = User.find_by id: params[:id]
    render_404 unless @user
  end
end
