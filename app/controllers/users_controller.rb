class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index]

  def index
    @users = User.paginate(:page => params[:page], :per_page => 20)
  end

  def destroy
    user = User.find(params[:id])
    if user.nil?
      flash[:error] = t("user.controller.destroy.error.notfound")
      redirect_to users_path
    else
      user.destroy
      redirect_to users_path, notice: t("user.controller.destroy.notice")
    end
  end
end