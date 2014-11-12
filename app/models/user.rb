class User < ActiveRecord::Base

  def self.find_or_create_by_omniauth(auth)
    self.where(email: auth.info.email).first ||
      self.create(email: auth.info.email, name: auth.info.name, avatar: auth.info.image)
  end

end
