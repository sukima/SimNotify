namespace :init do
  desc "One stop command to get a working environment from a cleaned source tree."
  task :all => ['init:config', 'db:schema:load', 'db:seed', 'mailer:views']
end

desc "Runs rake init:all"
task :init => 'init:all'
