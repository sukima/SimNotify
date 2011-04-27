############################
# Based on the original DreamHost deploy.rb recipe
#
#
require 'bundler/capistrano'
require File.expand_path "../sync", __FILE__

# GitHub settings #######################################################################################
set :repository,  "git@github.com:sukima/SimNotify.git" #GitHub clone URL
set :scm, "git"
set :scm_passphrase, "YE0wX8Kh" #This is the passphrase for the ssh key on the server deployed to
set :branch, "master"
set :scm_verbose, true
#########################################################################################################
set :user, 'simnotify' #Dreamhost username
set :domain, 'delphinus.dreamhost.com'  # Dreamhost servername where your account is located 
set :project, 'SimNotify'  # Your application as its called in the repository
set :application, 'schedulesimulation.com'  # Your app's location (domain or sub-domain name as setup in panel)
set :applicationdir, "/home/#{user}/#{application}"  # The standard Dreamhost setup
set :shared_assets, %w{public/system}
#########################################################################################################
# additional settings
default_run_options[:pty] = true  # Forgo errors when deploying from windows
#ssh_options[:keys] = %w(/Path/To/id_rsa)            # If you are using ssh_keys
#set :chmod755, "app config db lib public vendor script script/* public/disp*"
set :use_sudo, false

set :stage, "production"
set :sync_directories, shared_assets
set :sync_backups, 3

# Don't change this stuff, but you may want to set shared files at the end of the file ##################
# deploy config
set :deploy_to, applicationdir
set :deploy_via, :remote_cache

# roles (servers)
role :app, domain
role :web, domain
role :db,  domain, :primary => true

namespace :deploy do
 [:start, :stop].each do |t|
   desc "#{t} task is a no-op with mod_rails"
   task t, :roles => :app do ; end
 end
 task :restart, :roles => :app, :except => { :no_release => true } do
   run "touch #{release_path}/tmp/restart.txt"
 end
end

namespace :assets  do
  namespace :symlinks do
    desc "Setup application symlinks for shared assets"
    task :setup, :roles => [:app, :web] do
      shared_assets.each { |link| run "mkdir -p #{shared_path}/#{link}" }
    end

    desc "Link assets for current deploy to the shared location"
    task :update, :roles => [:app, :web] do
      shared_assets.each { |link| run "ln -nfs #{shared_path}/#{link} #{release_path}/#{link}" }
    end
  end
end

#########################################################################################################

before "deploy:setup" do
  assets.symlinks.setup
end

before "deploy:symlink" do
  assets.symlinks.update
end

#for use with shared files (e.g. config files)
after "deploy:update_code" do
  run "ln -s #{shared_path}/config.yml #{release_path}/config"
  run "ln -s #{shared_path}/database.yml #{release_path}/config"
  run "ln -s #{shared_path}/logo.png #{release_path}/public/images"
  run "ln -s #{shared_path}/htaccess #{release_path}/public/.htaccess"
  #run "ln -s #{shared_path}/environment.rb #{release_path}/config"
  run("cd #{release_path} && /usr/bin/env bundle exec rake mailer:views RAILS_ENV=production")
end

# vim:set ft=ruby sw=2 et:
