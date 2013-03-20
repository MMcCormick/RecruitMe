# == Schema Information
#
# Table name: positions
#
#  company_industry :string(255)
#  company_name     :string(255)
#  company_size     :string(255)
#  company_type     :string(255)
#  company_uid      :integer
#  end_date         :date
#  id               :integer          not null, primary key
#  is_current       :boolean
#  start_date       :date
#  summary          :text
#  title            :string(255)
#  uid              :integer
#  user_id          :integer
#

class Position < ActiveRecord::Base
  attr_protected

  belongs_to :user

  def total_time
    latest_date = end_date ? end_date : Date.today
    if start_date and latest_date
      (latest_date - start_date).to_i
    else
      nil
    end
  end
end
