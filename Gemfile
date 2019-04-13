source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.1.7' #-> Bumped the version
gem 'sprockets-rails' #-> this will add the latest version

gem 'rails-html-sanitizer', '~> 1.0.4'

gem 'pg', '0.18.4' # upgraded from '0.17.1' #PostgreSQL

# Use SCSS for stylesheets
gem 'bootstrap-sass', '~> 3.4.1'
gem 'sass-rails', '>= 3.2'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'

#use will_paginate to show big tables page by page
gem 'will_paginate', '~> 3.1'

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', '3.1.2'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

# gem to export to Excel
gem 'rubyzip', '>= 1.2.1'
gem 'axlsx', git: 'https://github.com/randym/axlsx.git', ref: '776037c0fc799bb09da8c9ea47980bd3bf296874'
gem 'axlsx_rails'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

gem 'rails_12factor' #for deployment to Heroku

# for datepicker
# https://github.com/Nerian/bootstrap-datepicker-rails
gem 'bootstrap-datepicker-rails'

gem 'byebug'

group :development do
  gem 'rails_layout'  #gem to set up for bootstrap css and js http://railsapps.github.io/twitter-bootstrap-rails.html
  gem 'annotate'  #adds annotations to models, call bundle exec annotate to make it work
  gem 'listen'
end

group :test do
  gem "connection_pool"

  gem "poltergeist"
  gem 'capybara'
  gem 'rb-fsevent'

  #for model tests
  gem 'shoulda', '~> 3.5'
  #gem "shoulda-context"
  gem "shoulda-matchers", '~> 2.0'

  #for color coding of test results
  gem 'minitest-reporters'

  #to use the assigns testing feature in Rails 5
  gem 'rails-controller-testing'
end

# Use puma as the app server
gem 'puma'

ruby '2.4.2'