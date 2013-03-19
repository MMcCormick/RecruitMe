class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_in_path_for(r)
    if r.created_at > 10.minutes.ago && !(r.name and r.email and r.industry and r.location_name and r.interest_level)
      step_1_path
    else
      user_path(r)
    end
  end
end
