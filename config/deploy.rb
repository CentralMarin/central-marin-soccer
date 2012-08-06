#setup bundler
require 'bundler/capistrano'

#setup multistage
set :stages, %w(staging production)
set :default_stage, 'staging'
require 'capistrano/ext/multistage'

set :application, "centralmarinsoccer"

#deployment details
set :deploy_via, :remote_cache
set :user, "dfadmin"
set :use_sudo, false
set :deploy_to do
  path = "/webapps/#{application}"
  path << "-#{stage}" unless stage.to_s == "production"
  path
end
set :rails_env do
  stage
end

#repo details
set :scm, :git
set :repository, "git@github.com:CentralMarin/Soccer.git"
set :branch, "release"

# bundle install has to be run before assets can be precompiled
before "deploy:assets:precompile", "bundle:install"

# remove old releases
after "deploy", "deploy:cleanup"

#server details
set :domain, "207.104.28.18"
role :web,domain                          # Your HTTP server, Apache/etc
role :app,domain                          # This may be the same as your `Web` server
role :db, domain, :primary => true # This is where Rails migrations will run

namespace :deploy do
  desc "run 'bundle install' to install Bundler's packaged gems for the current deploy"
  task :bundle_install, :roles => :app do
    run "cd #{release_path} && bundle install"
  end

  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do Nothing
  end

  desc "Restart Application"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end


