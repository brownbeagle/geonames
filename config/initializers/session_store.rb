# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_geonames_session',
  :secret      => '13f9a9740d7a0530bc19599efad1c4fa6d4ee41a51ddda7663f590f1e7f0c21405e7a37929ab7b691945e1d1256b87d2893c76093589505aac16811da33f6ea2'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
