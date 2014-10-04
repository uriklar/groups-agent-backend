class Result < ActiveRecord::Base
  belongs_to :user
  belongs_to :post

  scope :todays, -> {
   	where("updated_at >= ?", Time.zone.now.beginning_of_day)
 	}
end
