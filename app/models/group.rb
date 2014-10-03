class Group < ActiveRecord::Base
  has_and_belongs_to_many :requests

  def keywords
  	k_words = []
  	requests.each do |request|
  		k_words.concat(request.keywords)
  	end
  	k_words
  end

  def auth_token
  	requests.first.user.auth_token
  end
end
