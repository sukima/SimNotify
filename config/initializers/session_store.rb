# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_SimNotify_session',
  :secret      => 'e25c30b59785f8947856c45a0df4fc1cb2f5ff7267ca3f5507b05278b5d477f3c4c27059ab94e3f7b37fc51cf1446999a53f08824131076c80b4bbcaf21bb29a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
