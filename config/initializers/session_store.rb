# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_todotopia_session',
  :secret      => '8a7a7041fed589d656229344413c543c03d505ba63f7478b68000c3981c7636789e9f1871d285dcd03a85ddc0a2c5e3b95f19f433e86b6103f0c400da4f8643c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
