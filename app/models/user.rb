# == Schema Information
#
# Table name: users
#
#  country_code           :string(255)
#  created_at             :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  id                     :integer          not null, primary key
#  industry               :string(255)
#  interest_level         :string(255)
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string(255)
#  location_name          :string(255)
#  name                   :string(255)
#  provider               :string(255)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  sign_in_count          :integer          default(0)
#  uid                    :string(255)
#  updated_at             :datetime
#

class User < ActiveRecord::Base

  @interest_levels = ['Active', 'Passive', 'Dream Job Only', 'Hidden']

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:linkedin]

  # Setup accessible (or protected) attributes for your model
  attr_protected

  validates_inclusion_of :interest_level, :in => @interest_levels, :allow_blank => true

  has_many :positions, :dependent => :destroy

  after_create :assign_codename

  def first_name
    name.split(' ').first
  end

  def assign_codename
    new_codename = Codename.where(:used => false).order("RANDOM()").first
    if new_codename
      self.codename = new_codename.name
      save
      new_codename.used = true
      new_codename.save
    end
  end

  def self.interest_levels
    @interest_levels
  end

  def self.find_for_linkedin_oauth(auth, signed_in_resource=nil)
    # Just for testing
    #user = User.where(:provider => auth.provider, :uid => auth.uid).first
    #user.destroy if user

    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      # Use Linkedin gem to get authenticated user's full profile
      client = LinkedIn::Client.new(ENV["LINKEDIN_CONSUMER"], ENV["LINKEDIN_SECRET"])
      client.authorize_from_access(auth.credentials.token, auth.credentials.secret)
      profile = client.profile(:scope => "r_fullprofile", :fields => %w(id email-address formatted-name positions industry location))

      # Hash of user fields
      user_fields = {
        name: profile['formatted-name'],
        provider: auth.provider,
        uid: auth.uid,
        email: profile['email-address'],
        password: Devise.friendly_token[0,20],
        industry: profile['industry']
      }
      # Fields that would cause trouble if top level hash were empty
      user_fields[:location_name] = profile['location']['name'] if profile['location']
      user_fields[:country_code] = profile['location']['country']['code'] if profile['location'] and profile['location']['country']
      user = User.create(user_fields)

      # If the user saved, get their positions
      if user.persisted?
        profile['positions']['all'].each do |p|
          c = p['company']
          # Hash of position fields
          params = {company_uid: c['id'],
                    company_industry: c['industry'],
                    company_name: c['name'],
                    company_size: c['size'],
                    company_type: c['type'],
                    uid: p['id'],
                    title: p['title'],
                    summary: p['summary'],
                    is_current: p['is_current']
          }
          # Fields that would cause trouble if top level hash were empty
          params[:end_date] = DateTime.new(p['end_date']['year'], p['end_date']['month']) if p['end_date']
          params[:start_date] = DateTime.new(p['start_date']['year'], p['start_date']['month']) if p['start_date']
          user.positions.create(params)
        end
      end
    end
    user
  end
end
