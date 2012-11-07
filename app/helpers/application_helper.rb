module ApplicationHelper
  def body_classes
    @body_classes ||= [controller.controller_name, "#{controller.controller_name}_#{controller.action_name}"]
  end

  def menu
   [
       ['menu.home', root_path],
       ['menu.teams', teams_path],
       ['menu.coaches', coaches_path],
       ['menu.tournaments', tournaments_path],
       ['menu.referees', referees_path],
       ['menu.news', articles_index_path]
    ].map do |item|
      menu_item item, (@top_level_section_name == item[0]) ? 'current' : 'single-link'
   end
   .join('')
   .html_safe
  end
	
	def menu_secondary
   [
       ['menu.calendar', calendar_path],
       ['menu.newsletter', root_path],
       ['menu.facebook', root_path],
       ['menu.clubInfo', root_path],
       ['menu.contact', root_path]
    ].map do |item|
      menu_item item, (@top_level_section_name == item[0]) ? 'current' : 'single-link'
   end
   .join('')
   .html_safe
  end



  private

  LANGUAGE_MENU_ITEM = ['menu.language', "http://#{AppConfig[:switch_hosts][I18n.locale]}"]

  def menu_item item, class_name
    content_tag :li, class_name == 'current' ? content_tag(:span, I18n.t(item[0])) : link_to(I18n.t(item[0]), item[1]), :class => class_name
  end
end
