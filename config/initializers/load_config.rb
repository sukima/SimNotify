# uses local config via YAML.
# See RailCast:
# http://railscasts.com/episodes/85-yaml-configuration-file

APP_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/config.yml")
APP_CONFIG.merge!(APP_CONFIG['environment'][RAILS_ENV])
APP_CONFIG.delete('environment')
APP_CONFIG.symbolize_keys!
APP_CONFIG[:application_version] = "1.2.3"
APP_CONFIG[:gui_themes] = Dir.entries("#{RAILS_ROOT}/public/stylesheets/#{APP_CONFIG[:theme_dir]}")[2..1000]
APP_CONFIG[:default_theme] = APP_CONFIG[:gui_themes][0] if APP_CONFIG[:default_theme].blank?

# Allow turning on and off mail via custom config (default: true)
APP_CONFIG[:send_emails] = true if APP_CONFIG[:send_emails].nil?
ActionMailer::Base.perform_deliveries = APP_CONFIG[:send_emails]
