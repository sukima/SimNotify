namespace :notifications do
  desc "Sends email notifications"
  task :send => :environment do
    ApplicationMailer.send_upcoming_notifications
  end
end
