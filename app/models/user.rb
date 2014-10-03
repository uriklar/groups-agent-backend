class User < ActiveRecord::Base
  has_many :requests
  has_many :results
  has_many :posts, :through => :results

  scope :with_results, -> {
 		joins(:results).
   	where("results.updated_at >= ?", Time.zone.now.beginning_of_day).
   	group("users.id")
 	}
end
