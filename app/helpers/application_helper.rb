module ApplicationHelper  
  def dt_item_if condition, dt, dd
    if condition
      content_tag(:dt, dt) + content_tag(:dd, dd)
    end
  end
  
  def display_title
    @display_title || t('project')
  end
end
