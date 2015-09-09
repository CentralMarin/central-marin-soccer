
def recreate_image(model)
  if model.image.file && model.image.file.exists?
    print "Updating image: #{model.image.path} ... "
    model.image.recreate_versions!
    model.save!
    puts "Success: #{model.image.path}"
  end
end

namespace :uploaded_images do
  desc "Consolidate images into uploads folder and rename to hash of filename"
  task :migrate => [:environment] do |t,args|

    # Articles
    puts "Migrating article images"
    Article.all.each { |article| recreate_image(article) }

    # Teams
    puts "Migrating team images"
    Team.all.each { |team| recreate_image(team) }

    # Coaches
    puts "Migrating coach images"
    Coach.all.each { |coach| recreate_image(coach) }

    # Contacts
    puts "Migrating contact images"
    Contact.all.each { |contact| recreate_image(contact) }

  end

end
