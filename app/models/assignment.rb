class Assignment < ActiveRecord::Base
  belongs_to :exchange
  belongs_to :elf, class_name: "User"
  belongs_to :recipient, class_name: "User"
end
