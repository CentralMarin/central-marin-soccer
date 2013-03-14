server '192.168.33.10', :app, :web, :db, :primary => true
set :user, 'vagrant'
set :rails_env, :vagrant
