namespace :html do
  path_parts = ["db", "web_parts"]

  desc "Exports all of the web parts as individual html files to the db/web_parts folder"
  task :export => :environment do
    I18n.available_locales.each do |locale|
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
        web_part = WebPart.find_by_name(name)
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
end