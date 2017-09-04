class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :show, :index, :destroy]
  before_action :correct_user, only: [:edit, :update, :show]
  before_action :admin_user, only: [:destroy, :index]

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    redirect_to root_url unless @user.activated?
  end

  def create
    @user = User.new(user_params)
    User.transaction do
      if (@user.save)
        @user.assignments.first_or_create!(user_id: @user.id, role_id: Role::REGULAR_USER) #test na validaciu ci kazdy user bude mat rolu
        @user.send_activation_email
        flash[:info] = "Please check your email to activate your account."
        redirect_to root_url
      else
        render 'new'
      end
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Zmeny boli uložené."
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_path
    end
  end

  def correct_user
    user = User.find_by(id: params[:id])
    redirect_to current_user unless current_user?(user)
  end

  def admin_user
    unless current_user.role?(:admin)
      flash[:info] = "Only admin can view this page."
      redirect_to user_path(current_user)
    end
  end

end
