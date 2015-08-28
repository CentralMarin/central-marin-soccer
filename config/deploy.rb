# config valid only for Capistrano 3.1
lock '3.4.0'

config = YAML.load_file('config/secrets.yml')

server '207.104.28.18', user: "#{config['development']['server_user']}",roles: %w{app, web, db}

# Source Control
set :application, 'centralmarinsoccer'
set :repo_url, 'git@github.com:CentralMarin/central-marin-soccer.git'
set :branch, 'release'

#deployment details
set :deploy_via, :remote_cache
set :copy_exclude, ['.git']
set :user, config['development']['server_user']
set :use_sudo, false
set :deploy_to, "/webapps/centralmarinsoccer"

set :linked_files, %w{config/secrets.yml config/CentralMarinSoccerTryouts.p12}
set :linked_dirs, %w{public/uploads public/assets public/system log public/ckeditor_assets}

# Default value for keep_releases is 5
set :keep_releases, 5

SSHKit.config.command_map[:rake] = "bundle exec rake"

namespace :deploy do
  desc "Create initial folder structure"
  task :setup do
    run "mkdir -p #{shared_path}/config"
  end

  # Update our database
  after :deploy, :migrate

  # remove old releases
  after :deploy, :cleanup

  # restart app server
  after :deploy, :'passenger:restart'
end
