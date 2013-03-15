# == Schema Information
#
# Table name: positions
#
#  company_name :string(255)
#  company_size :string(255)
#  company_type :string(255)
#  company_uid  :integer
#  end_date     :datetime
#  id           :integer          not null, primary key
#  industry     :string(255)
#  is_current   :boolean
#  start_date   :datetime
#  title        :string(255)
#  uid          :integer
#  user_id      :integer
#

class Position < ActiveRecord::Base
  attr_protected

  belongs_to :user
end
