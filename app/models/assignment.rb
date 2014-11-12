class Assignment < ActiveRecord::Base
  has_one :santa, class_name: "User"
  has_one :recipient, class_name: "User"
end
