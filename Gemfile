source 'http://rubygems.org'

gem 'rails', '3.1.10'
gem 'rake', '0.8.7'
gem 'jquery-rails', '>= 1.0.12'
gem 'will_paginate', '~> 3.0'
gem 'prawn'

group :production do
  gem 'pg'
  gem 'thin'
  gem 'newrelic_rpm'
end

group :development, :test do
  gem 'sqlite3'
  gem 'letter_opener', '0.0.2'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '3.1.4'
  gem 'uglifier'
end

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end
