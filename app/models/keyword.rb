class Keyword < ActiveRecord::Base
  has_and_belongs_to_many :requests

  def users
  	requests.map{ |r| r.user }
  end
end
