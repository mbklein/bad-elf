require 'digest/sha2'

class Exchange < ActiveRecord::Base
  has_many :assignments, dependent: :destroy
  belongs_to :owner, class_name: "User"
  
  before_save :generate_invite_code
  
  def self.for_user user
    user.nil? ?  Exchange.none : (Exchange.where(owner_id: user.id) + Assignment.where(elf_id: user.id).collect(&:exchange)).uniq
  end
  
  def generate_invite_code
    unless self.invite_code.present?
      sha = Digest::SHA512.new
      sha << Time.now.to_s
      self.invite_code = sha.to_s[0..9]
    end
    
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
  
  def matched?(one, two)
    assignments.where(elf_id: one.id, recipient_id: two.id).present? or assignments.where(elf_id: two.id, recipient_id: one.id).present?
  end
  
  def clear!
    assignments.each { |a| a.update_attribute :recipient, nil }
  end
  
  def shuffle!
    update_attribute(:closed, true)
    clear!
    user_map = participants.shuffle
    user_map << user_map.first
    while user_map.length > 1
      elf = user_map.shift
      recipient = user_map.first
      assignments.where(elf_id: elf.id).first.update_attribute(:recipient_id, recipient.id)
    end
  end
end
