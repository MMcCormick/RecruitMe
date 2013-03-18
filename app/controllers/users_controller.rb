class UsersController < ActionController::Base
  layout "application"

  def show
    @user = User.find(params[:id])
  end
end