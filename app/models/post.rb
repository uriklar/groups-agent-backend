class Post < ActiveRecord::Base
  has_many :results
  has_many :users, :through => :results
end
