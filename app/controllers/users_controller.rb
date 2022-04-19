class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update]
  before_action :check_user, only: [:edit, :update]

  def index
    @users = User.all
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "ユーザー情報を更新しました"
      redirect_to edit_user_path(@user)
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :email, :user_image, :user_introduction)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def check_user
    if @user != current_user
      flash[:notice] = "不正なアクセスです"
      redireft_to root_path
    end
  end
end
