namespace :html do
  path_parts = ["db", "web_parts"]

  desc "Exports all of the web parts as individual html files to the db/web_parts folder"
  task :export => :environment do
    I18n.available_locales.each do |locale|

      # Set the locale
      I18n.locale = locale

      web_parts = WebPart.all
      web_parts.each do |web_part|
        filename = File.join(Rails.root, path_parts[0], path_parts[1], web_part.name + "." + locale.to_s + ".html")
        File.open(filename, 'w') do |file|
          puts "Writing file: #{filename}"
          file.puts web_part.html
        end
      end
    end
  end

  desc "Imports all of the web parts from the db/web_parts folder into the database updating existing and creating new records as necessary"
  task :import  => :environment do
    # Get all of the files in the directory
    path = File.join(Rails.root, path_parts[0], path_parts[1])
    Dir.foreach(path) do |filename|
      if File.extname(filename) == '.html'
        # parse off the locale and name
        match_data = /([\w\.]*)\.(\w*)\.html$/.match(filename)
        name = match_data[1]
        locale = match_data[2]

        # Load the html
        html = nil
        File.open(File.join(path, filename), 'r') do |file|
          html = file.read
        end

        puts "Importing Name: #{name} for Locale: #{locale}"

        # Set the locale
        I18n.locale = locale

        # see if the name already exists and either add or update
        web_part = WebPart.find_by(name: name)
        if web_part.nil?
          web_part = WebPart.new
          web_part.name = name
        end
        web_part.html = html
        web_part.save
      end

    end
  end

  desc "First exports existing content and then imports all content. Useful when creating new nodes"
  task :export_import => [:export, :import]

  desc "Create page and web part associations"
  task :setup_cms => :environment do
    create_page('Information', '/information', ['information.overview'])
    create_page('Gold', '/information/gold', ['information.gold'])
    create_page('Silver', '/information/silver', ['information.silver'])
    create_page('Academy', '/information/academy', ['information.academy'])
    create_page('On Equal Footing', '/information/on-equal-footing', ['information.scholarship'])
    create_page('Referees', '/referees', ['information.referee'])
    create_page('Tournaments', '/tournaments', ['information.tournaments', 'information.tournaments.mission_bell', 'information.tournaments.premier_challenge', 'information.tournaments.footer'])
    create_page('Coaching', '/coaching', ['coaching.overview'])
  end

  def create_page(name, url, web_part_names)
    page = Page.find_by(name: name)
    if page.nil?
      page = Page.create(name: name, url: url)
    end

    # Associate web parts
    web_part_names.each do |web_part_name|
      web_part = WebPart.find_by(name: web_part_name)
      if not web_part.nil?
        web_part.page = page
        web_part.save
      else
        puts "Unable to locate web_part #{web_part_name} to associate with page #{name}"
      end
    end
  end
end