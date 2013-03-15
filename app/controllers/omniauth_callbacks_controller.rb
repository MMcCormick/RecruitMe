class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def passthru
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end

  def linkedin
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_linkedin_oauth(request.env["omniauth.auth"], current_user)

    foo = request.env["omniauth.auth"]

    client = LinkedIn::Client.new(ENV["LINKEDIN_CONSUMER"], ENV["LINKEDIN_SECRET"])
    rtoken = request.env["omniauth.auth"]['credentials']['token']
    rsecret = request.env["omniauth.auth"]['credentials']['secret']

    # then fetch your access keys
    client.authorize_from_access(rtoken, rsecret)

    foo = client.profile(:fields => ['picture-url', 'headline', :positions])

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Linkedin") if is_navigational_format?
    else
      session["devise.linkedin_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end