class UsersController < ApplicationController
  before_action :logged_in_user, except: [:create, :show, :new]
  before_action :find_user, except: [:new, :create, :index]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  

  def index
    @users = User.paginate page: params[:page]
  end

  def show
    if @user.nil?
      flash[:success] = "Not found ID" 
      redirect_to root_path
    end
    @microposts = @user.microposts.order_by_created_at.paginate page: params[:page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params    
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render "edit"
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private
  def find_user
    @user = User.find_by id: params[:id]
    if @user.nil?
      flash[:danger] = "User not found"
      redirect_to root_path
    end
  end

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def correct_user
    redirect_to root_url unless current_user.current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
