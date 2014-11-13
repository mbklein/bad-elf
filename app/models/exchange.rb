require 'digest/sha2'

class Exchange < ActiveRecord::Base
  has_many :assignments, dependent: :destroy
  belongs_to :owner, class_name: "User"
  
  after_initialize :generate_invite_code
  
  def self.for_user user
    user.nil? ?  Exchange.none : (Exchange.where(owner_id: user.id) + Assignment.where(elf_id: user.id).collect(&:exchange)).uniq
  end
  
  def generate_invite_code
    self.invite_code ||= Digest::SHA512.new.to_s[0..9]
  end
  
  def participants
    assignments.collect &:elf
  end
  
  def participating? user
    participants.include? user
  end
  
  def assigned?
    assignments.all? { |a| a.recipient.present? }
  end
end
