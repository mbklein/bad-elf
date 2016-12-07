module ApplicationHelper  
  def dt_item_if condition, dt, dd
    if condition
      content_tag(:dt, dt) + content_tag(:dd, dd)
    end
  end
  
  def display_title
    @display_title || t('project')
  end
  
  def glyph(*names)
    options = (names.last.kind_of?(Hash)) ? names.pop : {}
    names.map! { |name| name.to_s.gsub('_','-') }
    names.map! do |name|
      name =~ /pull-(?:left|right)/ ? name : "glyphicon glyphicon-#{name}"
    end
    options[:tag] = options[:tag] ||= :i
    content_tag options[:tag], nil, :class => names
  end
end
