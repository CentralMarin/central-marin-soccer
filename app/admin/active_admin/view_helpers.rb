module ActiveAdmin::ViewHelpers
  def html_overview(html)
    truncate(strip_tags(html), :length => 400, :omission => ' ...', :separator => ' ')
  end

  def html_stripped(html)
    strip_tags(html)
  end
end