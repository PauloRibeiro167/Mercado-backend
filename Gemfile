source "https://rubygems.org"

# Core Rails
gem "rails", "~> 8.0.3"

# Database
gem "pg", "~> 1.1"

# user
gem 'devise', '~> 4.9', '>= 4.9.4'

# Server
gem "puma", ">= 5.0"

# Caching and Background Jobs
gem "solid_cache"
gem "solid_queue"

# Performance
gem "bootsnap", require: false

# Deployment
gem "kamal", require: false
gem "thruster", require: false

# Timezone data
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Uncomment if needed
# gem "jbuilder"
# gem "bcrypt", "~> 3.1.7"
# gem "image_processing", "~> 1.2"
# gem "rack-cors"

group :development do
  # Debugging
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Security analysis
  gem "brakeman", require: false

  # Code style
  gem "rubocop-rails-omakase", require: false

  # ER Diagram generation
  gem "rails-erd"
end

group :test do
  # Add test-specific gems here if needed
end
