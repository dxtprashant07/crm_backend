source "https://rubygems.org"
ruby "~> 3.2.0"

gem "rails", "~> 7.1"
gem "puma", "~> 6.0"
gem "sqlite3", "~> 1.7"
gem "rack-cors"
gem "bcrypt", "~> 3.1"
gem "jwt", "~> 2.7"
gem "kaminari"
gem "bootsnap", require: false
gem "tzinfo-data", platforms: %i[windows jruby]

group :production do
  gem "pg"   # PostgreSQL for Render production database
end

group :development, :test do
  gem "rspec-rails", "~> 6.0"
  gem "factory_bot_rails"
  gem "faker"
  gem "pry-rails"
end
