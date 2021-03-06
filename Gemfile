source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.6'
# Use sqlite3 as the database for Active Record
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 4.3', '>= 4.3.1'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
gem 'therubyracer', platforms: :ruby #本番環境に必要
gem 'mysql2', '>= 0.3.18', '< 0.5'

gem 'dotenv-rails', '~> 2.2', '>= 2.2.1'
gem 'kaminari', '~> 0.17.0'
gem 'elo', '~> 0.1.0'
gem 'devise', '~> 4.4', '>= 4.4.3'
gem 'nokogiri', '~> 1.8', '>= 1.8.2'
gem 'jquery-turbolinks', '~> 2.1'
gem 'bootstrap', '~> 4.0.0.beta2.1'
gem 'browser', '~> 2.5', '>= 2.5.3'
gem 'rmagick', '~> 2.16'
gem 'counter_culture', '~> 1.8'
gem 'omniauth', '~> 1.8', '>= 1.8.1'
gem 'omniauth-twitter', '~> 1.4'
# gem 'omniauth-instagram'
gem 'omniauth-google-oauth2', '~> 0.5.3'
gem 'clipboard-rails', '~> 1.7', '>= 1.7.1'

group :production do
  gem 'aws-sdk', '1.61'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "guard-rspec"
  gem "spring-commands-rspec"
end

group :test do
  gem "faker"
  gem "capybara"
  gem "database_cleaner"
  gem "launchy"
  gem "selenium-webdriver"
  gem "shoulda-matchers"
  gem 'rails-controller-testing'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
