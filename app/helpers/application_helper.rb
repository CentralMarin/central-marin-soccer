module ApplicationHelper
  def body_classes
    @body_classes ||= [controller.controller_name, "#{controller.controller_name}_#{controller.action_name}"]
  end

  def analytics_tracking_id
    production_tracking_id = {en: 'UA-39121765-1', es: 'UA-39121765-2'}
    staging_tracking_id = {en: 'UA-39121765-3', es: 'UA-39121765-4'}
    if Rails.env == 'production'
      production_tracking_id[I18n.locale]
    else
      staging_tracking_id[I18n.locale]
    end
  end

  def menu
    [
        ['menu.home', root_path],
        ['menu.teams', teams_path],
        ['menu.academy', academy_path],
        ['menu.coaches', coaches_path],
        ['menu.tournaments', tournaments_path],
        ['menu.referees', referees_path],
        ['menu.news', articles_path],
        ['menu.tryout', tryouts_path]
    ].map do |item|
      menu_item item, (@top_level_section_name == item[0]) ? 'current' : 'single-link'
    end
    .join('')
    .html_safe
  end

  def menu_secondary
    [
        ['menu.calendar', calendar_path],
        ['menu.facebook', "https://www.facebook.com/CentralMarinSoccerClub"],
        ['menu.clubInfo', information_path],
        ['menu.contact', contact_path],
        ['menu.language', "#{request.protocol}#{AppConfig[:switch_hosts][I18n.locale]}:#{request.port}#{request.fullpath}"]
    ].map do |item|
      menu_item item, (@top_level_section_name == item[0]) ? 'current' : 'single-link'
    end
    .join('')
    .html_safe
  end
  
  def cms_region(web_parts, part_name, tag, tag_class = '')

    # Make sure we have an array of classes
    if tag_class.kind_of? String
      tag_class = [tag_class]
    end

    tag_attributes = {class: tag_class}
    if session[:edit_pages]
      tag_attributes[:class].push('editable')
      tag_attributes[:data] = {name: part_name }
    end
    if web_parts[part_name].nil? || web_parts[part_name].html.nil?
      html = "<H1><B>Load HTML Content</B></H1>".html_safe
    else
      html = web_parts[part_name].html.html_safe
    end

    content_tag(tag, html, tag_attributes)
  end

  def show_article(article)

    case article.category
      when :club     # route to the index page with an anchor to the article
        path = articles_path
      when :team     # route to the team page with an anchor to the article
        path = team_path article.team_id
      else
        # TODO: Need to determine the location for other categories
    end

    path  + "#" + article.to_param

  end

  private

  def menu_item item, class_name
    content_tag :li, class_name == 'current' ? content_tag(:span, I18n.t(item[0])) : link_to(I18n.t(item[0]), item[1]), :class => class_name
  end
end
