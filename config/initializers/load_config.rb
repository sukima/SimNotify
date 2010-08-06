# uses local config via YAML.
# See RailCast:
# http://railscasts.com/episodes/85-yaml-configuration-file

APP_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/config.yml")
APP_CONFIG.merge!(APP_CONFIG['environment'][RAILS_ENV])
APP_CONFIG.delete('environment')

ActionMailer::Base.smtp_settings = YAML.load_file("#{RAILS_ROOT}/config/email.yml")[RAILS_ENV]
