require 'sprite_factory'

namespace :assets do
  desc 'recreate sprite images and css'
  task :resprite => :environment do
    SpriteFactory.cssurl = "image-url('$IMAGE')" # use a sass-rails helper method to be evaluated by the rails asset pipeline
    SpriteFactory.run!('app/assets/images/coach')
  end
end