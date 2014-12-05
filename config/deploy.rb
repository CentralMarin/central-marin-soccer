# config valid only for Capistrano 3.1
lock '3.2.1'

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

set :linked_files, %w{config/secrets.yml}
set :linked_dirs, %w{public/uploads public/assets public/system log}
#
#set :ssh_options, {
#    verbose: :debug
#}

##setup whenever for cron support
##require "whenever/capistrano"
##set :whenever_environment, #{stage}
##set :whenever_identifier, "#{application}_#{stage}"

# Default value for keep_releases is 5
set :keep_releases, 5

SSHKit.config.command_map[:rake] = "bundle exec rake"

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  #desc 'Symbolic linking uploads directory'
  #task :symlink_uploads do
  #  run "mkdir -p #{shared_path}/uploads"
  #  run "#{try_sudo} chmod 777 #{shared_path}/uploads"
  #  run "ln -nfs #{shared_path}/uploads  #{release_path}/public/uploads"
  #end

  desc "Create initial folder structure"
  task :setup do
    run "mkdir -p #{shared_path}/config"
  end

  # Update our database
  after :deploy, :migrate

  # remove old releases
  after :deploy, :cleanup

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
