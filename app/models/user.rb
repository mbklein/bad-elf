class User < ActiveRecord::Base
  has_many :exchanges, foreign_key: 'owner_id', dependent: :destroy
  has_many :elf_assignments, class_name: 'Assignment', foreign_key: 'elf_id', dependent: :destroy
  has_many :recipient_assignments, class_name: 'Assignment', foreign_key: 'recipient_id', dependent: :destroy
  
  def self.find_or_create_by_omniauth(auth)
    self.where(email: auth.info.email).first ||
      self.create(email: auth.info.email, name: auth.info.name, avatar: auth.info.image)
  end

  def participating? exchange
    exchange.participating? self
  end
end
