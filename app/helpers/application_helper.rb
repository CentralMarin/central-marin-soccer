module ApplicationHelper
  def body_classes
    @body_classes ||= [controller.controller_name, "#{controller.controller_name}_#{controller.action_name}"]
  end

  def menu
   [
       ['menu.home', root_path],
       ['menu.teams', teams_path],
       ['menu.academy', academy_path],
       ['menu.coaches', coaches_path],
       ['menu.tournaments', tournaments_path],
       ['menu.referees', referees_path],
       ['menu.news', articles_path]
    ].map do |item|
      menu_item item, (@top_level_section_name == item[0]) ? 'current' : 'single-link'
   end
   .join('')
   .html_safe
  end
	
	def menu_secondary
   [
       ['menu.calendar', calendar_path],
       ['menu.facebook', "http://www.facebook.com"],
       ['menu.clubInfo', information_path],
       ['menu.contact', contact_path],
       ['menu.language', "http://#{AppConfig[:switch_hosts][I18n.locale]}"]
    ].map do |item|
      menu_item item, (@top_level_section_name == item[0]) ? 'current' : 'single-link'
   end
   .join('')
   .html_safe
  end

  def editable_attributes(part_name)
    if @editable
      {:class => 'editable', contenteditable: true, :data => {:name => part_name}}
    else
      {}
    end
  end

  def editable_content(part_name)
    @web_parts[part_name].html.html_safe
  end

  private

  def menu_item item, class_name
    content_tag :li, class_name == 'current' ? content_tag(:span, I18n.t(item[0])) : link_to(I18n.t(item[0]), item[1]), :class => class_name
  end
end
