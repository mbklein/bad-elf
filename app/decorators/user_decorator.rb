class UserDecorator < Draper::Decorator
  decorates_finders
  delegate_all

  def avatar_image
    h.image_tag self.avatar, class: 'user-avatar'
  end
end
