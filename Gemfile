source 'https://rubygems.org'

ruby '2.0.0'

gem 'rails', '3.2.13'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'

# Auth
gem 'devise'
gem 'cancan'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-openstreetmap'

# Frontend Stuff
gem 'haml-rails'
gem 'jquery-rails', '~> 2.1.4'
gem 'bourbon'
gem 'high_voltage'
gem 'recaptcha', :require => "recaptcha/rails"
gem "rails_admin_map_field", :git => "git://github.com/jmoe/rails_admin_map_field.git"
gem 'rails3-jquery-autocomplete'
gem 'kaminari'
gem 'rack-iframe'
gem 'truncate_html'
gem 'simple_form_fancy_uploads'
gem 'simple_form'
gem 'rails_admin'

# HTTPS
gem "httparty"
gem 'hpricot'
gem 'excon'
gem 'ruby_parser'

# Attachments
gem "fog", "~> 1.3.1"
gem 'carrierwave'
gem 'mini_magick'
gem 'flickraw-cached'

# JSON
gem 'rabl'
gem 'multi_json'
gem 'yajl-ruby'

# Geo
gem 'geocoder'
gem 'rgeo'
gem 'georuby', :require => "geo_ruby"

# Versions
gem 'paper_trail', '~> 2'

# Testing helper
gem 'database_cleaner'

# Simple Mailer
gem 'pony'

# Addons
gem 'figaro'
gem 'memcachier'
gem 'dalli'
gem 'bugsnag'
gem 'newrelic_rpm'

# Zipfiles
gem 'rubyzip'

# Webserver
gem 'puma'

gem 'rails_12factor', group: :production

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'yui-compressor'
  gem 'uglifier', '>= 1.0.3'
end

group :test, :development do
  gem "rspec-rails", "~> 2.0"
  gem "factory_girl_rails"
end

group :development do
  gem "binding_of_caller"
  gem "better_errors"
  gem "meta_request"
end

group :test do
  gem "capybara"
  gem "launchy"
end

gem 'simplecov', :require => false, :group => :test

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
