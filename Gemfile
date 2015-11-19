source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

gem 'pg', '0.17.1' #PostgreSQL

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

#use will_paginate to show big tables page by page
gem 'will_paginate', '~> 3.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

gem 'rails_12factor' #for deployment to Heroku

gem 'bootstrap-sass', '~> 3.2.0' #include bootstrap css and js files

# for datepicker
# https://github.com/Nerian/bootstrap-datepicker-rails
gem 'bootstrap-datepicker-rails'


group :development do
  gem 'rails_layout'  #gem to set up for bootstrap css and js http://railsapps.github.io/twitter-bootstrap-rails.html
  gem 'annotate'  #adds annotations to models, call bundle exec annotate to make it work
end

group :test do
  gem 'capybara'
  gem 'rb-fsevent'
  #gem 'growl'  #not needed if we don't want notifications from guard.
  gem 'guard-spork'
  gem 'spork-rails'
  gem 'factory_girl_rails'

  gem 'cucumber-rails', '1.4.0', :require => false
  gem 'database_cleaner', github: 'bmabey/database_cleaner'
end

group :development, :text do
  gem 'rspec-rails'
  gem 'guard-rspec'
end

# Use unicorn as the app server
group :production do
  gem 'unicorn'
end

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

ruby "2.0.0"