class Admin::UsersController < ApplicationController

  before_filter :check_admin

  def index
    @users = User.order("firstname").page(params[:page]).per(4)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      
      redirect_to movies_path
    else
      render :new
    end
  end

  def destroy
    # user = user.find_by(id: params[:id])

    user = User.find_by(id: params[:id])
    UserMailer.deleted_email(user).deliver
    user.destroy! unless user == current_user
    redirect_to :back
  end


  protected

  def user_params
    params.require(:user).permit(:email, :firstname, :lastname, :password, :password_confirmation, :admin)
  end

  def check_admin
    redirect_to :login unless current_user.admin
  end



end
