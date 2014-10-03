class Request < ActiveRecord::Base
  has_and_belongs_to_many :groups
  has_and_belongs_to_many :keywords
  belongs_to :user
end
