class UserDecorator < Draper::Decorator
  decorates_finders
  delegate_all

  def avatar_image
    h.image_tag self.avatar, class: 'user-avatar'
  end

  def formatted_address
    self.address.present? ? self.address.lines.collect(&:chomp).join('<br/>').html_safe : I18n.t('user.address_missing')
  end

  def formatted_additional_info
    self.additional_info.present? ? %{<ul><li>#{self.additional_info.lines.collect(&:chomp).join('</li><li>')}</li></ul>}.html_safe : I18n.t('user.additional_info_missing')
  end
end
