ENV = {}
config = YAML.load(File.read('config/application.yml'))
#config.merge! config.fetch(Rails.env, {})
config.each do |key, value|
  ENV[key] = value.to_s unless value.kind_of? Hash
end

#setup bundler
require 'bundler/capistrano'
#setup multistage
set :stages, %w(vagrant staging production)
set :default_stage, 'staging'
require 'capistrano/ext/multistage'

#setup whenever for cron support
set :whenever_environment, defer { stage }
set :whenever_identifier, defer { "#{application}_#{stage}" }
require "whenever/capistrano"

set :application, "centralmarinsoccer"

#deployment details
set :deploy_via, :remote_cache
set :copy_exclude, ['.git']
set :user, ENV['SERVER_USER']
set :use_sudo, false
set :deploy_to do
  path = "/webapps/#{application}"
  path << "-#{stage}" if stage.to_s == "staging"
  path
end

#repo details
set :scm, :git
set :repository, "git@github.com:CentralMarin/central-marin-soccer.git"
set :branch, "release"

# bundle install has to be run before assets can be precompiled
before "deploy:assets:precompile", "bundle:install"

# Update our database
after "deploy", "deploy:migrate"

# remove old releases
after "deploy", "deploy:cleanup"

# create our symlink
after 'deploy:update_code', 'deploy:symlink_uploads'

before 'deploy:assets:precompile' do
  run "ln -s #{shared_path}/config/application.yml #{release_path}/config/application.yml"
end

namespace :deploy do
  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      begin
        from = source.next_revision(current_revision)
      rescue
        err_no = true
      end
      if err_no || capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
        run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
      else
        logger.info "Skipping asset pre-compilation because there were no asset changes"
      end
    end
  end

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

  task :symlink_uploads do
    run "mkdir -p #{shared_path}/uploads"
    run "#{try_sudo} chmod 777 #{shared_path}/uploads"
    run "ln -nfs #{shared_path}/uploads  #{release_path}/public/uploads"
  end

  task :setup do
    run "mkdir -p #{shared_path}/config"
  end
end




