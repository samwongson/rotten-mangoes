class Admin::UsersController < ApplicationController

  def index
    if current_user.admin
      @users = User.order("firstname").page(params[:page]).per(4)
    end
  end

end
