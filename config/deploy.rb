require "bundler/capistrano"

set :application, "rumpetroll.motherfrog.com"
set :repository,  "git@github.com:danielmahal/Rumpetroll.git"
set :scm, :git
set :user, "deploy"
set :use_sudo, false

system('ssh-add')
ssh_options[:forward_agent] = true


role :web, "50.56.33.132"
role :app, "50.56.33.132"
# role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"


namespace :deploy do
  
  rumpetrolld_bin = "#{File.join(current_path,'bin','rumpetrolld')}"
  
  task :start do
    run "#{try_sudo} #{rumpetrolld_bin} start"
  end
  task :stop do 
    run "#{try_sudo} #{rumpetrolld_bin} stop"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} #{rumpetrolld_bin} restart"
  end
  
  task :symlink_data do
    # run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "mkdir -p #{shared_path}/data"
    run "ln -nfs #{shared_path}/data #{release_path}/data"
  end
  
end

after "deploy:symlink","deploy:symlink_data"
