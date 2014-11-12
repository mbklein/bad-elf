class Exchange < ActiveRecord::Base
  has_many :assignments
  belongs_to :owner, class_name: "User"
end
