source 'http://rubygems.org'

gem 'rails', '3.1.4'
gem 'rake', '0.8.7'
gem 'jquery-rails', '>= 1.0.12'
gem 'will_paginate', '~> 3.0'
gem 'formtastic'
gem 'prawn'

group :production do
  gem 'pg'
  gem 'thin'
  gem 'newrelic_rpm'
end

group :development, :test do
  gem 'sqlite3'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '3.1.4'
  gem 'coffee-rails', '~> 3.1.0'
  gem 'uglifier'
end

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end
