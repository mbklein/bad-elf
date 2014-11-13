class ExchangeDecorator < Draper::Decorator
  decorates_finders
  delegate_all
  
  def join_link
    h.join_exchange_url(id: self.invite_code)
  end
  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

end
