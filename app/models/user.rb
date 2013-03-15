# == Schema Information
#
# Table name: users
#
#  created_at             :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  id                     :integer          not null, primary key
#  industry               :string(255)
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string(255)
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
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:linkedin]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :name, :provider, :uid, :industry

  has_many :positions, :dependent => :destroy

  def self.find_for_linkedin_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      client = LinkedIn::Client.new(ENV["LINKEDIN_CONSUMER"], ENV["LINKEDIN_SECRET"])
      client.authorize_from_access(auth.credentials.token, auth.credentials.secret)
      profile = client.profile(:scope => "r_fullprofile", :fields => %w(id email-address formatted-name positions industry))

      user = User.create(name:profile['formatted-name'],
                         provider:auth.provider,
                         uid:auth.uid,
                         email:profile['email-address'],
                         password:Devise.friendly_token[0,20],
                         industry:profile['industry']
      )
      if user.persisted?
        profile['positions']['all'].each do |p|
          c = p['company']
          params = {company_uid: c['id'],
                    company_industry: c['industry'],
                    company_name: c['name'],
                    company_size: c['size'],
                    company_type: c['type'],
                    uid: p['id'],
                    title: p['title'],
                    is_current: p['is_current'],
          }
          params[:end_date] = DateTime.new(p['end_date']['year'], p['end_date']['month']) if p['end_date']
          params[:start_date] = DateTime.new(p['start_date']['year'], p['start_date']['month']) if p['start_date']
          user.positions.create(params)
        end
      end
    end
    user
  end
end
