class UserDecorator < Draper::Decorator
  decorates_finders
  delegate_all

  def avatar_image
    h.image_tag self.avatar, class: 'user-avatar'
  end
  
  def formatted_address
    self.address.present? ? self.address.lines.collect(&:chomp).join('<br/>').html_safe : I18n.t('user.address_missing')
  end
end
