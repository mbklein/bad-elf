module ApplicationHelper  
  def dt_item_if condition, dt, dd
    if condition
      content_tag(:dt, dt) + content_tag(:dd, dd)
    end
  end
end
