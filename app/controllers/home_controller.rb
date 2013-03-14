class HomeController < ActionController::Base
  layout "application"
  def index
    foo = current_user
    bar = "bar"
  end
end
